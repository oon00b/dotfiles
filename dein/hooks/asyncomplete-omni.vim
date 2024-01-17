" hook_source {{{
function! s:vim_cmdline_omni(findstart, base) abort
    let l:cmpline = strpart(getline('.'), 0, col('.') - 1)

    if a:findstart == 1
        let l:last_wordpos = match(cmpline, '\v[^[:space:]]+$')
        return l:last_wordpos < 1 ? col('.') - 1 : l:last_wordpos
    endif

    return getcompletion(cmpline, 'cmdline')
endfunction

augroup dein-hook_asyncomplete-omni.vim
    autocmd!
    autocmd Filetype * if &omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif
    autocmd Filetype vim let &l:omnifunc = expand('<SID>') .. 'vim_cmdline_omni'
augroup END

call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
\ 'name': 'omni'
\ , 'allowlist': ['*']
\ , 'blocklist': ['c', 'cpp', 'html']
\ , 'triggers': {
    \ 'vim': ' /:'
\ }
\ , 'completor': function('asyncomplete#sources#omni#completor')
\ , 'config': {
\   'show_source_kind': 1
\ , }
\ }))
" }}}
