" hook_source {{{

let g:asyncomplete_auto_completeopt = 0

" 補完候補を 'priority' オプションの大きい順にソートする
function! s:sort_by_priority_preprocessor(options, matches) abort
  let l:items = []
  for [l:source_name, l:matches] in items(a:matches)
    for l:item in l:matches['items']
      if stridx(l:item['word'], a:options['base']) == 0
        let l:item['priority'] =
            \ get(asyncomplete#get_source_info(l:source_name), 'priority', 0)
        call add(l:items, l:item)
      endif
    endfor
  endfor

  let l:items = sort(l:items, {a, b -> b['priority'] - a['priority']})

  call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]

" 保管候補のリスト
let s:current_buffer_matches = []

function! s:set_current_buffer_matches() abort
    let s:current_buffer_matches =
                \ getline(1, '$')
                \ ->join("\n")
                \ ->split('\v[^[:keyword:]]')
                \ ->map({_, word -> {'word':word, 'dup': 0}})
endfunction

" 現在のバッファから単語を抽出し、保管候補として表示する。
function! s:current_buffer_completor(opt, ctx) abort
    " 現在カーソルが存在する列
    let l:cursor_column = a:ctx['col']

    " 現在の行のすでに入力されている文字列(行頭から、(カーソルの列 - 1) までの文字列)
    let l:typed_string = a:ctx['typed']

    let l:keyword = matchstr(l:typed_string, '\v[[:keyword:]]+$')
    let l:keyword_length = len(l:keyword)

    " 補完を開始する位置
    let l:start_column = l:cursor_column - l:keyword_length

    call timer_start(400, {_ -> asyncomplete#complete(a:opt['name'], a:ctx, l:start_column, s:current_buffer_matches)})
endfunction

autocmd User asyncomplete_setup call asyncomplete#register_source({
    \ 'name': 'current_buffer'
    \ , 'allowlist': ['*']
    \ , 'events': ['TextChangedI']
    \ , 'on_event': {_name, _ctx, _event, -> s:set_current_buffer_matches()}
    \ , 'completor': function('s:current_buffer_completor')
    \ , 'priority': -10
    \ })

" }}}
