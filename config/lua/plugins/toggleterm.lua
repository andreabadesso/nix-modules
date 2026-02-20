require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  persist_mode = true,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
    width = function()
      return math.floor(vim.o.columns * 0.9)
    end,
    height = function()
      return math.floor(vim.o.lines * 0.9)
    end,
    winblend = 0,
  },
  winbar = {
    enabled = false,
  },
})

-- Keybindings for different terminal layouts
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle horizontal terminal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle vertical terminal" })

-- Terminal mode mappings (using modern autocmd API)
-- Note: <Esc><Esc> exits terminal mode (defined in claude-code.lua)
-- Single <Esc> is kept for terminal apps like Claude Code
local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  -- Window navigation from terminal mode
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.api.nvim_create_autocmd('TermOpen', {
  pattern = 'term://*',
  callback = set_terminal_keymaps,
})
