require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "tokyonight",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "neo-tree", "toggleterm" },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      "branch",
      {
        "diff",
        symbols = { added = "+", modified = "~", removed = "-" },
      },
      {
        "diagnostics",
        symbols = { error = "E", warn = "W", info = "I", hint = "H" },
      },
    },
    lualine_c = {
      {
        "filename",
        file_status = true,
        newfile_status = true,
        path = 1, -- Relative path
        symbols = {
          modified = "[+]",
          readonly = "[-]",
          unnamed = "[No Name]",
          newfile = "[New]",
        },
      },
    },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = { "neo-tree", "fugitive", "trouble", "toggleterm" },
})
