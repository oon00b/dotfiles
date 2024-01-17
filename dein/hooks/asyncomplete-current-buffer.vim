" 保管候補のリスト
let s:current_buffer_matches = []

function! s:set_current_buffer_matches() abort
    let s:current_buffer_matches =
                \ getline(1, '$')
                \ ->join("\n")
                \ ->split('\v[^[:keyword:]]')
                \ ->map({_, word -> {'word': word, 'dup': 0, 'menu': 'buffer'}})
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

    call asyncomplete#complete(a:opt['name'], a:ctx, l:start_column, s:current_buffer_matches)
endfunction

call asyncomplete#register_source({
    \ 'name': 'current_buffer'
    \ , 'allowlist': ['*']
    \ , 'events': ['TextChangedI']
    \ , 'on_event': {_name, _ctx, _event, -> s:set_current_buffer_matches()}
    \ , 'completor': function('s:current_buffer_completor')
    \ })
