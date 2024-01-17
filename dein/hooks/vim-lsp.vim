" hook_source {{{
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_insert_mode_enabled = 0
let g:lsp_inlay_hints_enabled = 1
let g:lsp_inlay_hints_mode = {
            \ 'normal': ['curline']
            \}

augroup hook_vim_lsp
    autocmd User lsp_register_server anoremenu <silent> PopUp.Show\ definition :LspPeekDefinition<CR>
    autocmd User lsp_register_server anoremenu <silent> PopUp.Go\ to\ definition :LspDefinition<CR>
    autocmd User lsp_register_server anoremenu <silent> PopUp.Show\ infomation :LspHover<CR>
    autocmd User lsp_register_server anoremenu <silent> PopUp.Rename :LspRename<CR>
augroup END
" }}}
