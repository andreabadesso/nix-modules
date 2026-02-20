require('dressing').setup({
  input = {
    enabled = true,
    default_prompt = "➤ ",
    prompt_align = "left",
    insert_only = true,
    start_in_insert = true,
    border = "rounded",
    relative = "cursor",
    prefer_width = 40,
    width = nil,
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },
    win_options = {
      winblend = 0,
      wrap = false,
      list = true,
      listchars = "precedes:…,extends:…",
      sidescrolloff = 0,
    },
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },
  },
  select = {
    enabled = true,
    backend = { "telescope", "builtin" },
    trim_prompt = true,
    telescope = require('telescope.themes').get_cursor({
      layout_config = {
        height = 15,
      },
    }),
    builtin = {
      border = "rounded",
      relative = "editor",
      win_options = {
        winblend = 0,
      },
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },
    },
  },
})
