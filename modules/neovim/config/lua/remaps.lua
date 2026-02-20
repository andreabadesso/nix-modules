vim.keymap.set('n', '<leader>/', ':nohlsearch<cr>')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Visual mode improvements
vim.keymap.set('v', '<', '<gv', { desc = "Indent left and reselect" })
vim.keymap.set('v', '>', '>gv', { desc = "Indent right and reselect" })

-- Move selected lines up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Better paste in visual mode (don't overwrite register)
vim.keymap.set('v', 'p', '"_dP', { desc = "Paste without yanking" })

-- Quickfix navigation
vim.keymap.set('n', '[q', ':cprev<CR>', { desc = "Previous quickfix" })
vim.keymap.set('n', ']q', ':cnext<CR>', { desc = "Next quickfix" })
