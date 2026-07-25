local map = vim.keymap.set

-- ── Basics ──────────────────────────────────────────────────────────────────
map('n', '<leader>/', '<cmd>nohlsearch<cr>', { desc = "Clear search highlight" })
map('n', ';', ':', { desc = "Command mode" })
map('n', 'J', 'mzJ`z', { desc = "Join lines, keep cursor put" })

-- Rename the word under the cursor across the file (prefilled :s).
map('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Substitute word under cursor" })

-- Keep the cursor centred while jumping through a file.
map('n', '<C-d>', '<C-d>zz', { desc = "Half page down (centred)" })
map('n', '<C-u>', '<C-u>zz', { desc = "Half page up (centred)" })
map('n', 'n', 'nzzzv', { desc = "Next match (centred)" })
map('n', 'N', 'Nzzzv', { desc = "Previous match (centred)" })

-- ── Clipboard hygiene ───────────────────────────────────────────────────────
-- `clipboard = unnamedplus` means every delete would otherwise overwrite the
-- system clipboard. Route the incidental ones to the black hole instead.
map({ 'n', 'v' }, 'x', '"_x', { desc = "Delete char (no clipboard)" })
-- <leader>D, not <leader>d: diffview owns <leader>dv/dc/dh/df, and a bare
-- <leader>d map would make every one of them wait out `timeoutlen` first.
map({ 'n', 'v' }, '<leader>D', '"_d', { desc = "Delete without yanking" })
map('v', 'p', '"_dP', { desc = "Paste over selection, keep register" })

-- ── Visual mode ─────────────────────────────────────────────────────────────
map('v', '<', '<gv', { desc = "Indent left and reselect" })
map('v', '>', '>gv', { desc = "Indent right and reselect" })
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ── Buffers & quickfix ──────────────────────────────────────────────────────
map('n', '[q', '<cmd>cprev<cr>zz', { desc = "Previous quickfix" })
map('n', ']q', '<cmd>cnext<cr>zz', { desc = "Next quickfix" })
map('n', '[b', '<cmd>bprevious<cr>', { desc = "Previous buffer" })
map('n', ']b', '<cmd>bnext<cr>', { desc = "Next buffer" })
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = "Delete buffer" })

-- ── Writing ─────────────────────────────────────────────────────────────────
map('n', '<leader>w', '<cmd>write<cr>', { desc = "Write file" })

-- ── Toggles (<leader>u — UI/undo) ───────────────────────────────────────────
-- Undotree moves from bare <leader>u to <leader>ut so the whole prefix can be
-- a which-key group instead of a single binding blocking it.
map('n', '<leader>uw', function()
  vim.opt_local.wrap = not vim.wo.wrap
end, { desc = "Toggle wrap" })

map('n', '<leader>un', function()
  vim.opt_local.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle relative numbers" })

map('n', '<leader>us', function()
  vim.opt_local.spell = not vim.wo.spell
end, { desc = "Toggle spellcheck" })

map('n', '<leader>ud', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.notify("Diagnostics " .. (enabled and "disabled" or "enabled"))
end, { desc = "Toggle diagnostics" })
