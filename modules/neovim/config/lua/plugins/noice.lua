require("noice").setup({
  lsp = {
    -- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = {
      enabled = true,
    },
    signature = {
      enabled = false, -- Using blink.cmp's signature help
    },
    progress = {
      enabled = false, -- Using fidget.nvim for progress
    },
  },
  presets = {
    bottom_search = true, -- Use a classic bottom cmdline for search
    command_palette = true, -- Position the cmdline and popupmenu together
    long_message_to_split = true, -- Long messages will be sent to a split
    inc_rename = false, -- Enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- Add a border to hover docs and signature help
  },
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
    },
  },
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "virtualtext",
  },
  popupmenu = {
    enabled = true,
    backend = "nui",
  },
  notify = {
    enabled = true,
    view = "notify",
  },
  views = {
    cmdline_popup = {
      position = {
        row = 5,
        col = "50%",
      },
      size = {
        width = 60,
        height = "auto",
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
    popupmenu = {
      relative = "editor",
      position = {
        row = 8,
        col = "50%",
      },
      size = {
        width = 60,
        height = 10,
      },
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
  },
  routes = {
    -- Hide "written" messages
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    -- Hide search count messages
    {
      filter = {
        event = "msg_show",
        kind = "search_count",
      },
      opts = { skip = true },
    },
  },
})

-- Keybindings
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<cr>", { desc = "Dismiss notifications" })
vim.keymap.set("n", "<leader>nh", "<cmd>NoiceHistory<cr>", { desc = "Notification history" })
