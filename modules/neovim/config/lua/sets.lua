vim.g.mapleader = ','
vim.g.maplocalleader = '\\'

-- ── UI ──────────────────────────────────────────────────────────────────────
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.termguicolors = true
vim.opt.pumheight = 12
vim.opt.showmode = false -- lualine already shows the mode

-- Neovim 0.11+: one global border for every floating window (hover, signature,
-- diagnostics), so plugins no longer each need their own `border = 'rounded'`.
vim.opt.winborder = 'rounded'

-- ── Indentation ─────────────────────────────────────────────────────────────
vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.shiftround = true

-- ── Wrapping ────────────────────────────────────────────────────────────────
vim.opt.wrap = true
vim.opt.linebreak = true   -- break at word boundaries, not mid-word
vim.opt.breakindent = true -- keep indentation on wrapped lines

-- ── Files / persistence ─────────────────────────────────────────────────────
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.autoread = true
vim.opt.confirm = true -- prompt instead of failing on :q with unsaved changes
vim.opt.isfname:append('@-@')

-- ── Search ──────────────────────────────────────────────────────────────────
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true     -- ...unless the pattern contains an uppercase char
vim.opt.inccommand = 'split' -- live preview of :s/// results

-- ── Splits ──────────────────────────────────────────────────────────────────
vim.opt.splitright = true
vim.opt.splitbelow = true

-- ── Clipboard ───────────────────────────────────────────────────────────────
-- Share the unnamed register with the system clipboard. `x` and `<leader>d`
-- are remapped to the black hole register in remaps.lua so incidental deletes
-- don't clobber what you copied.
vim.opt.clipboard = 'unnamedplus'

-- ── Responsiveness ──────────────────────────────────────────────────────────
vim.opt.updatetime = 50
vim.opt.timeoutlen = 400 -- how long which-key waits before popping up
vim.opt.ttimeoutlen = 10

vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2

-- NOTE: FocusGained/FocusLost used to be in `eventignore` to stop stray [O/[I
-- bytes leaking into tmux. The tmux config now sets `focus-events on`, which
-- fixes that at the source — and leaving them ignored silently broke
-- `autoread` (external edits never reloaded) and gitsigns refresh on focus.

-- ── Providers ───────────────────────────────────────────────────────────────
-- Nothing here uses perl or ruby; skipping the host probe at startup is free
-- speed and drops two :checkhealth warnings.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
