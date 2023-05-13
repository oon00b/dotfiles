if exists('g:loaded_www_search')
    finish
endif

let g:loaded_www_search = 1

if !exists('g:www_search_terms_pattern')
    let g:www_search_terms_pattern = '\C\V{searchTerms}'
endif

function! s:escape_query(query)
    let l:result = ''

    let l:q = substitute(a:query, '\v[[:space:]]+', ' ', 'g')
    let l:q = substitute(l:q, '\v(^[[:space:]]|[[:space:]]$)', '', 'g')

    for i in range(strlen(l:q))
        let l:char = strpart(l:q, l:i, 1)

        if l:char =~# '\v^[0-9A-Za-z._~-]$'
            let l:result ..= l:char
        elseif l:char ==# ' '
            let l:result ..= '+'
        else
            let l:result ..= printf('%%%02X', char2nr(l:char, 1))
        endif
    endfor

    return l:result
endfunction

function! g:WWW_Search(search_url, query) abort
    let l:arg = shellescape(substitute(a:search_url, g:www_search_terms_pattern, s:escape_query(a:query), 'g'), 1)
                \ .. ' > /dev/null 2>&1'

    let l:browser_cmd = ''
    let Fork = {cmd -> executable('setsid') < 1 || has('osxdarwin') ? cmd .. ' &' : 'setsid -f ' .. cmd}

    let l:browser_env = expand('$BROWSER')
    if !empty(l:browser_env) && executable(l:browser_env)
        let l:browser_cmd = Fork(l:browser_env .. ' ' .. l:arg)
    elseif has('osxdarwin')
        if executable('open') > 0
            let l:browser_cmd = 'open ' .. l:arg
        endif
    elseif executable('xdg-open') > 0
        let l:browser_cmd = Fork('xdg-open ' .. l:arg)
    endif

    if !empty(l:browser_cmd)
        execute 'silent!' '!' .. l:browser_cmd
        redraw!
    endif
endfunction

function! g:DDGSearch(query) abort
    " <https://help.duckduckgo.com/duckduckgo-help-pages/settings/params/>
    let l:url = 'https://lite.duckduckgo.com/lite/?kd=-1&kh=1&kaf=1&q={searchTerms}'
    call g:WWW_Search(l:url, a:query)
endfunction

command! -nargs=1 DDGSearch call g:DDGSearch(<f-args>)

function! s:DDGSearchV() abort
    let l:old_unnamed_reg = getreginfo('"')
    let l:old_reg = getreginfo(v:register)
    noautocmd normal! ygv
    call g:DDGSearch(getreg(v:register))
    call setreg(v:register, l:old_reg)
    call setreg('"', l:old_unnamed_reg)
endfunction

vnoremenu <silent> PopUp.Search\ on\ DuckDuckGo <Cmd>call <SID>DDGSearchV()<CR>
