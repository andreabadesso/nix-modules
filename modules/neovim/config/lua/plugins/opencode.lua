-- Setup snacks.nvim (required by opencode.nvim, plus additional features)
require("snacks").setup({
  -- Required by opencode.nvim
  input = { enabled = true },
  picker = { enabled = true },
  terminal = { enabled = true },

  -- Dashboard on startup
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    },
  },

  -- Indent guides
  indent = {
    enabled = true,
    char = "|",
    only_scope = false,
    only_current = false,
    hl = "SnacksIndent",
  },

  -- Better notifications
  notifier = {
    enabled = true,
    timeout = 3000,
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true,
    sort = { "level", "added" },
    icons = {
      error = "E",
      warn = "W",
      info = "I",
      debug = "D",
      trace = "T",
    },
    style = "compact",
    top_down = true,
    date_format = "%R",
    more_format = " (%d more lines)",
    refresh = 50,
  },

  -- Smooth scrolling
  scroll = {
    enabled = true,
    animate = {
      duration = { step = 15, total = 250 },
      easing = "linear",
    },
    spamming = 10,
  },

  -- Scope highlighting
  scope = {
    enabled = true,
  },

  -- Word highlighting
  words = {
    enabled = true,
    debounce = 200,
    notify_jump = false,
    notify_end = true,
  },

  -- Statuscolumn
  statuscolumn = {
    enabled = false, -- Using default for now
  },

  -- Dim inactive windows
  dim = {
    enabled = true,
    animate = {
      enabled = true,
      duration = {
        step = 5,
        total = 100,
      },
    },
  },

  -- Zen mode
  zen = {
    enabled = true,
    toggles = {
      dim = true,
      git_signs = false,
      diagnostics = false,
    },
    show = {
      statusline = false,
      tabline = false,
    },
    win = { style = "zen" },
    zoom = {
      toggles = {},
      show = { statusline = true, tabline = true },
      win = {
        backdrop = false,
        width = 0,
      },
    },
  },
})

-- Snacks keybindings
vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
vim.keymap.set("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Toggle Zoom" })
vim.keymap.set("n", "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next reference" })
vim.keymap.set("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev reference" })

-- Setup opencode.nvim
require("opencode").setup({
  -- Use default configuration
  -- Full config options available in lua/opencode/config.lua
})
