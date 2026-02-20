-- Claude Code integration via coder/claudecode.nvim
-- Provides VS Code-like integration with Claude Code CLI

-- Double-escape to exit terminal mode (single Esc works in Claude)
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })

require("claudecode").setup({
  -- Terminal settings
  terminal = {
    split_side = "right",        -- Open Claude in right split
    split_width_percentage = 0.40, -- 40% of screen width
    provider = "snacks",         -- Use snacks.nvim for terminal (already installed)
  },

  -- WebSocket server settings
  server = {
    port_range = { min = 10000, max = 65535 },
  },

  -- Diff settings for when Claude proposes changes
  diff = {
    enabled = true,
    auto_close_on_accept = true,
    vertical_split = true,
  },

  -- Auto-start the MCP server when Neovim opens
  auto_start = true,

  -- Logging
  log_level = "warn",
})

-- Keybindings
-- Toggle Claude Code terminal
vim.keymap.set("n", "<leader>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
vim.keymap.set("n", "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude Code" })

-- Send selection to Claude (visual mode)
vim.keymap.set("v", "<leader>cs", "<cmd>ClaudeCodeSend<cr>", { desc = "Send selection to Claude" })

-- Quick actions for common tasks
vim.keymap.set("v", "<leader>ce", function()
  vim.cmd("ClaudeCodeSend")
  -- The selection is sent, user can type their prompt in Claude
end, { desc = "Explain selection" })

vim.keymap.set("v", "<leader>cr", function()
  vim.cmd("ClaudeCodeSend")
end, { desc = "Review selection" })

-- Diff management
vim.keymap.set("n", "<leader>cda", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept Claude's changes" })
vim.keymap.set("n", "<leader>cdd", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny Claude's changes" })

-- Tree-sitter integration for smart selection
vim.keymap.set("n", "<leader>cb", function()
  -- Select current code block and send to Claude
  vim.cmd("normal! vib")
  vim.cmd("ClaudeCodeSend")
end, { desc = "Send code block to Claude" })

vim.keymap.set("n", "<leader>cF", function()
  -- Select current function and send to Claude
  vim.cmd("normal! vaf")
  vim.cmd("ClaudeCodeSend")
end, { desc = "Send function to Claude" })
