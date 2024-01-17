let s:cache_dir = exists('$XDG_CACHE_HOME') ? expand('$XDG_CACHE_HOME') : expand('$HOME/.cache')
let s:dein_base = s:cache_dir .. '/dein'
let s:dein_src =  s:dein_base .. '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_src)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_src
endif
execute 'set runtimepath^=' .. s:dein_src

let s:dein_hooks_dir  = expand('<sfile>:p:h') .. '/hooks'
let s:dein_conf_files = [expand('<sfile>:p')] + glob(s:dein_hooks_dir .. '/*.vim', v:true, v:true)

let g:dein#auto_recache = v:true

if dein#min#load_state(s:dein_base)
    call dein#begin(s:dein_base, s:dein_conf_files)
    call dein#add(s:dein_src)

    if !has('nvim')
        call dein#add('vim-jp/vimdoc-ja')
    endif

    call dein#add('lifepillar/vim-solarized8'
                \ , {'hook_add': join([
                \ 'let g:solarized_italics = 0'
                \ , 'let g:solarized_visibility = "high"'
                \ , 'let g:solarized_statusline = "low"'
                \ , 'set background=dark'
                \ , 'colorscheme solarized8_flat'
                \ ], "\n")})

    call dein#add('https://gitlab.com/HiPhish/info.vim.git'
                \ , {'hook_add': 'autocmd FileType info setlocal nonumber norelativenumber'})

    call dein#add('prabirshrestha/vim-lsp'
                \ , {
                \ 'hooks_file': s:dein_hooks_dir .. '/vim-lsp.vim'
                \ , 'lazy': v:true
                \ , 'on_event': ['BufEnter']
                \ , 'on_source': ['asyncomplete.vim']
                \})

    call dein#add('mattn/vim-lsp-settings'
                \ , {
                \ 'lazy': v:true
                \ , 'on_source': ['vim-lsp']
                \})

    call dein#add('prabirshrestha/asyncomplete.vim'
                \ , {
                \ 'lazy': v:true
                \ , 'on_event': ['BufEnter']
                \ , 'hook_add': join([
                \ 'let g:asyncomplete_auto_completeopt = 0'
                \ ])
                \})

    call dein#add('prabirshrestha/asyncomplete-lsp.vim'
                \ , {
                \ 'lazy': v:true
                \ , 'on_source': ['asyncomplete.vim']
                \})

    call dein#add('FuDesign2008/asyncomplete-smart-fuzzy.vim'
                \ , {
                \ 'lazy': v:true
                \ , 'on_source': ['asyncomplete.vim']
                \})

    call dein#add('yami-beta/asyncomplete-omni.vim'
                \ , {
                \ 'hooks_file': s:dein_hooks_dir .. '/asyncomplete-omni.vim'
                \ , 'lazy': v:true
                \})

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif

function! s:setup_completer() abort
    if exists('g:completer_loaded') || lsp#get_server_status() =~? '\v(running|starting)'
        return
    endif

    let g:completer_loaded = 1

    call dein#source('asyncomplete-omni.vim')
    source `=s:dein_hooks_dir .. '/asyncomplete-current-buffer.vim'`
endfunction

augroup dein_conf
    autocmd!
    autocmd BufWinEnter * call autocmd_add([{
                \ 'event': 'InsertEnter'
                \ , 'group': 'dein_conf'
                \ , 'bufnr': bufnr()
                \ , 'cmd': 'call s:setup_completer()'
                \, 'once': v:true
                \}])
augroup END

