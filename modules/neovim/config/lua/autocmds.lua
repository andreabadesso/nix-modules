local function augroup(name)
  return vim.api.nvim_create_augroup("andrevim_" .. name, { clear = true })
end

-- Briefly highlight whatever you just yanked — the cheapest possible
-- confirmation that the motion grabbed what you meant.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 120 })
  end,
})

-- Reopen a file where you left it.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function(ev)
    if vim.bo[ev.buf].filetype:match("commit") then return end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- `autoread` only reloads when Neovim is told to check. Do it on focus and
-- when re-entering a buffer, so files changed by git/Claude/formatters show up.
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "BufEnter" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
})

-- Resize splits proportionally when the terminal window changes size
-- (tmux pane resize, Ghostty window resize).
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current)
  end,
})

-- `q` closes throwaway/read-only windows instead of hunting for the plugin's
-- own close mapping.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help", "qf", "man", "checkhealth", "lspinfo", "startuptime",
    "fugitive", "fugitiveblame", "gitsigns.blame", "neotest-output",
    "neotest-summary", "neotest-output-panel",
  },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})

-- Pressing `o`/`O` on a comment line shouldn't start another comment.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("no_comment_continuation"),
  callback = function()
    vim.opt_local.formatoptions:remove({ "o", "r" })
  end,
})

-- Writing to a path whose directory doesn't exist yet just works.
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(ev)
    if ev.match:match("^%w%w+://") then return end
    local dir = vim.fn.fnamemodify(vim.uv.fs_realpath(ev.match) or ev.match, ":p:h")
    vim.fn.mkdir(dir, "p")
  end,
})

-- Soft-wrap and spellcheck prose, not code.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.colorcolumn = ""
  end,
})

-- Opt-in whitespace cleanup: `:TrimWhitespace`. Deliberately not automatic —
-- stripping whitespace on every save in someone else's repo produces diff
-- noise that has nothing to do with your change.
vim.api.nvim_create_user_command("TrimWhitespace", function()
  local view = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(view)
end, { desc = "Strip trailing whitespace in the current buffer" })
