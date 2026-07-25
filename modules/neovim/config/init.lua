-- ── Core ────────────────────────────────────────────────────────────────────
-- `sets` first: it defines mapleader, which every keymap registered below
-- captures by value at definition time.
require('sets')
require('colors')
require('remaps')
require('autocmds')

-- ── Editing / language ──────────────────────────────────────────────────────
require('plugins/lsp')
require('plugins/treesitter')
require('plugins/surround')
require('plugins/conform')
require('plugins/autopairs')

-- ── UI ──────────────────────────────────────────────────────────────────────
require('plugins/snacks')
require('plugins/telescope')
require('plugins/neo-tree')
require('plugins/oil')
require('plugins/fugitive')
require('plugins/gitsigns')
require('plugins/dressing')
require('plugins/undotree')
require('plugins/coverage')
require('plugins/claude-code')
require('plugins/render-markdown')
require('plugins/which-key')
require('plugins/noice')
require('plugins/lualine')
require('plugins/flash')
require('plugins/harpoon')
require('plugins/fidget')

-- ── Deferred ────────────────────────────────────────────────────────────────
-- Nothing here is needed to read the file you just opened, so it loads once
-- the first frame is on screen.
vim.defer_fn(function()
  require('plugins/trouble')
  require('plugins/diffview')
  require('plugins/neotest')
  require('plugins/toggleterm')
end, 100)
