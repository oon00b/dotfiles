let s:cache_dir = exists('$XDG_CACHE_HOME') ? expand('$XDG_CACHE_HOME') : expand('$HOME/.cache')
let s:dein_base = s:cache_dir .. '/dein'
let s:dein_src =  s:dein_base .. '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_src)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_src
endif
execute 'set runtimepath^=' .. s:dein_src

let g:dein#auto_recache = 1

let s:dein_hooks_dir  = expand('<sfile>:p:h') .. '/hooks'
let s:dein_conf_files = [expand('<sfile>:p')] + glob(s:dein_hooks_dir .. '/*.vim', v:true, v:true)

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
                \ , 'set background=dark'
                \ , 'colorscheme solarized8'
                \ ], "\n")})

    call dein#add('https://gitlab.com/HiPhish/info.vim.git'
                \ , {'hook_add': 'autocmd FileType info setlocal nonumber norelativenumber'})

    " asyncomplete.vimは'BufEnter'イベントにあわせて有効化されるので、それより後のイベントで読み込むとうまく動かないっぽい。
    call dein#add('prabirshrestha/asyncomplete.vim'
                \ , {
                \ 'hooks_file': s:dein_hooks_dir .. '/asyncomplete.vim'
                \ , 'lazy': v:true
                \ , 'on_event': ['BufEnter']
                \})

    call dein#add('yami-beta/asyncomplete-omni.vim'
                \ , {
                \ 'hooks_file': s:dein_hooks_dir .. '/asyncomplete-omni.vim'
                \ , 'lazy': v:true
                \ , 'on_source': ['asyncomplete.vim']
                \})

    call dein#add('FuDesign2008/asyncomplete-smart-fuzzy.vim'
                \ , {
                \ 'lazy': v:true
                \ , 'on_source': ['asyncomplete.vim']
                \})

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
    call dein#install()
endif
