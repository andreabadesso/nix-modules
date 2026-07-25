-- <leader>ut, not bare <leader>u: <leader>u is now the UI-toggle group
-- (<leader>uw wrap, <leader>uf format-on-save, ...) and a bare mapping on the
-- prefix would stall every one of them for `timeoutlen`.
vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })
