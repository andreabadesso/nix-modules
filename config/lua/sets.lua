vim.g.mapleader = ','

vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.updatetime = 50
vim.opt.colorcolumn = '80'

vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2

-- Enable autoread for opencode.nvim to reload buffers
vim.opt.autoread = true

-- Disable focus events to prevent [O and [I characters in tmux
vim.opt.eventignore:append({ "FocusGained", "FocusLost" })
