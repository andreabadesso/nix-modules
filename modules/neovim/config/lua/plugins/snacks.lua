-- snacks.nvim was installed but `setup()` was never called (its only config
-- lived in a plugins/opencode.lua that init.lua never required), so every
-- feature below was dead weight in the closure. This wires up the pieces that
-- don't duplicate a plugin already in use:
--
--   input   -> dressing.nvim owns vim.ui.input
--   picker  -> telescope owns fuzzy finding
--   notifier-> noice owns vim.notify
--
-- ...are all left off deliberately to avoid two plugins fighting over the same
-- override.

require("snacks").setup({
  -- Strip syntax/LSP/folds off pathologically large files instead of hanging.
  bigfile = { enabled = true },

  -- Render the file before plugins finish loading — makes `nvim <file>` feel
  -- instant.
  quickfile = { enabled = true },

  -- Terminal backend for claudecode.nvim (`provider = "snacks"`).
  terminal = { enabled = true },

  indent = {
    enabled = true,
    indent = { char = "│" },
    scope = { char = "│" },
    animate = { enabled = false }, -- animation over SSH/tmux reads as lag
  },

  scope = { enabled = true },

  -- Highlight and navigate other occurrences of the symbol under the cursor.
  words = { enabled = true, notify_jump = false },

  zen = {
    toggles = { dim = true, git_signs = false, diagnostics = false },
    show = { statusline = false, tabline = false },
  },

  -- LSP-aware file rename, wired into oil/neo-tree below.
  rename = { enabled = true },

  -- Explicitly off: owned by another plugin, or too noisy in a tmux pane.
  input = { enabled = false },
  picker = { enabled = false },
  notifier = { enabled = false },
  dashboard = { enabled = false },
  scroll = { enabled = false },
  dim = { enabled = false },
  statuscolumn = { enabled = false },
})

local map = vim.keymap.set

map("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen mode" })
map("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Zoom window" })

-- `]]`/`[[` are already taken by treesitter class navigation, so references
-- get `]r`/`[r` instead of the upstream default.
map("n", "]r", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next reference" })
map("n", "[r", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Previous reference" })

map("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Open in browser (git)" })
map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Blame line (float)" })

map("n", "<leader>rF", function() Snacks.rename.rename_file() end, { desc = "Rename file (LSP-aware)" })

-- Let neo-tree's rename go through Snacks so LSP import paths get updated too.
vim.api.nvim_create_autocmd("User", {
  pattern = "NeoTreeWillRenamePath",
  group = vim.api.nvim_create_augroup("andrevim_snacks_rename", { clear = true }),
  callback = function(args)
    Snacks.rename.on_rename_file(args.data.source, args.data.destination)
  end,
})
