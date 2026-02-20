require("which-key").setup({
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  icons = {
    breadcrumb = ">>",
    separator = "->",
    group = "+",
  },
  win = {
    border = "rounded",
    padding = { 1, 2 },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
  },
  show_help = true,
  show_keys = true,
})

-- Register key groups for better organization
require("which-key").add({
  { "<leader>f", group = "Find/Files" },
  { "<leader>g", group = "Git" },
  { "<leader>h", group = "Hunk/Git" },
  { "<leader>j", group = "Test (Jest)" },
  { "<leader>t", group = "Terminal/Toggle" },
  { "<leader>x", group = "Trouble/Diagnostics" },
  { "<leader>c", group = "Claude Code" },
  { "<leader>cd", group = "Claude Diff" },
  { "<leader>v", group = "View/LSP" },
  { "<leader>m", group = "Harpoon marks" },
  { "<leader>n", group = "Notifications" },
})
