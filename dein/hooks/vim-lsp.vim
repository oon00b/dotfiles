" hook_source {{{
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_insert_mode_enabled = 0
let g:lsp_signature_help_enabled = 0

augroup hook_vim_lsp
    autocmd User lsp_register_server anoremenu <silent> PopUp.Show\ definition   <Cmd>LspPeekDefinition<CR>
    autocmd User lsp_register_server anoremenu <silent> PopUp.Go\ to\ definition <Cmd>LspDefinition<CR>
    autocmd User lsp_register_server anoremenu <silent> PopUp.Show\ infomation   <Cmd>LspHover<CR>
    autocmd User lsp_register_server anoremenu <silent> PopUp.Rename             <Cmd>LspRename<CR>
augroup END
" }}}
