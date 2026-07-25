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
    mappings = false, -- no icon column; keeps the popup narrow in a tmux pane
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

-- Group labels. These are kept in sync with what the plugin files actually
-- map — the previous list advertised prefixes that no longer existed and
-- mislabelled <leader>n (neo-tree lives there too, not just notifications).
require("which-key").add({
  { "<leader>b", group = "Buffer" },
  { "<leader>c", group = "Claude Code / Code" },
  { "<leader>cd", group = "Claude diff" },
  { "<leader>d", group = "Diffview" },
  { "<leader>f", group = "Find / Format" },
  { "<leader>g", group = "Git" },
  { "<leader>h", group = "Git hunks" },
  { "<leader>j", group = "Tests (Jest)" },
  { "<leader>m", group = "Harpoon marks" },
  { "<leader>n", group = "Notifications / Tree" },
  { "<leader>r", group = "Rename / References" },
  { "<leader>t", group = "Terminal / Toggles" },
  { "<leader>u", group = "UI toggles" },
  { "<leader>v", group = "View / LSP" },
  { "<leader>x", group = "Trouble / Diagnostics" },
  { "[", group = "Previous" },
  { "]", group = "Next" },
})
