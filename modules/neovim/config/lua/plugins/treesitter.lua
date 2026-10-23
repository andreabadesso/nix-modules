-- nvim-treesitter's `main` branch (what nixpkgs ships since 26.05) dropped
-- the `nvim-treesitter.configs` module system. Parsers still come from Nix
-- (nvim-treesitter.withPlugins); highlighting is started by hand with the
-- core vim.treesitter API, and textobjects get explicit keymaps.

-- Highlighting. Treesitter-only (no legacy vim regex syntax fallback), so
-- too low a size cap leaves normal source files completely unhighlighted.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("nix_treesitter_highlight", { clear = true }),
  callback = function(args)
    if vim.api.nvim_buf_line_count(args.buf) > 10000 then return end
    -- pcall: filetypes without a parser (help popups, plugin UIs) just skip.
    pcall(vim.treesitter.start, args.buf)
  end,
})

-- Textobjects
require("nvim-treesitter-textobjects").setup {
  select = {
    lookahead = true, -- Automatically jump forward to textobj
    selection_modes = {
      ['@parameter.outer'] = 'v',
      ['@function.outer'] = 'V',
      ['@class.outer'] = 'V',
    },
    include_surrounding_whitespace = true,
  },
  move = {
    set_jumps = true, -- Whether to set jumps in the jumplist
  },
}

local select = require("nvim-treesitter-textobjects.select")
for lhs, spec in pairs({
  -- Function textobjects
  ["af"] = { "@function.outer", "Select around function" },
  ["if"] = { "@function.inner", "Select inside function" },
  -- Class textobjects
  ["ac"] = { "@class.outer", "Select around class" },
  ["ic"] = { "@class.inner", "Select inside class" },
  -- Parameter/argument textobjects
  ["aa"] = { "@parameter.outer", "Select around argument" },
  ["ia"] = { "@parameter.inner", "Select inside argument" },
  -- Block textobjects
  ["ab"] = { "@block.outer", "Select around block" },
  ["ib"] = { "@block.inner", "Select inside block" },
  -- Conditional textobjects
  ["ai"] = { "@conditional.outer", "Select around conditional" },
  ["ii"] = { "@conditional.inner", "Select inside conditional" },
  -- Loop textobjects
  ["al"] = { "@loop.outer", "Select around loop" },
  ["il"] = { "@loop.inner", "Select inside loop" },
  -- Comment textobjects
  ["a/"] = { "@comment.outer", "Select around comment" },
}) do
  vim.keymap.set({ "x", "o" }, lhs, function()
    select.select_textobject(spec[1], "textobjects")
  end, { desc = spec[2] })
end

local move = require("nvim-treesitter-textobjects.move")
for fn, maps in pairs({
  goto_next_start = {
    ["]m"] = { "@function.outer", "Next function start" },
    ["]]"] = { "@class.outer", "Next class start" },
    ["]a"] = { "@parameter.inner", "Next argument" },
  },
  goto_next_end = {
    ["]M"] = { "@function.outer", "Next function end" },
    ["]["] = { "@class.outer", "Next class end" },
  },
  goto_previous_start = {
    ["[m"] = { "@function.outer", "Previous function start" },
    ["[["] = { "@class.outer", "Previous class start" },
    ["[a"] = { "@parameter.inner", "Previous argument" },
  },
  goto_previous_end = {
    ["[M"] = { "@function.outer", "Previous function end" },
    ["[]"] = { "@class.outer", "Previous class end" },
  },
}) do
  for lhs, spec in pairs(maps) do
    vim.keymap.set({ "n", "x", "o" }, lhs, function()
      move[fn](spec[1], "textobjects")
    end, { desc = spec[2] })
  end
end

local swap = require("nvim-treesitter-textobjects.swap")
vim.keymap.set("n", "<leader>a", function()
  swap.swap_next("@parameter.inner")
end, { desc = "Swap with next argument" })
vim.keymap.set("n", "<leader>A", function()
  swap.swap_previous("@parameter.inner")
end, { desc = "Swap with previous argument" })

-- Incremental selection: the plugin module is gone, but nvim 0.12 ships the
-- same thing in core as visual-mode `an` (parent node) and `in` (child node).
-- Keep the old keys on top of it.
vim.keymap.set("n", "<C-space>", "van", { remap = true, desc = "Start node selection" })
vim.keymap.set("x", "<C-space>", "an", { remap = true, desc = "Expand to parent node" })
vim.keymap.set("x", "<bs>", "in", { remap = true, desc = "Shrink to child node" })

-- Fix for neotest: its child processes don't inherit our runtimepath, so they
-- can't find the Nix-managed parsers. Mirror them into a stable directory.
--
-- The mirroring shells out, so it runs deferred rather than on the startup
-- path — the parsers are only needed once neotest actually spawns something.
local parser_install_dir = vim.fn.stdpath("data") .. "/nix-treesitter-parsers"
vim.opt.runtimepath:append(parser_install_dir)

vim.defer_fn(function()
  local parser_path = vim.api.nvim_get_runtime_file("parser", false)[1]
  if not parser_path then return end

  -- Skip the shell-out when the mirror is already pointed at this store path;
  -- it only changes when the neovim derivation is rebuilt.
  local stamp = parser_install_dir .. "/.source"
  local current = (vim.fn.filereadable(stamp) == 1) and vim.fn.readfile(stamp)[1] or nil
  if current == parser_path then return end

  vim.fn.mkdir(parser_install_dir, "p")
  vim.fn.system(string.format("ln -sfn %s/* %s/", parser_path, parser_install_dir))
  vim.fn.writefile({ parser_path }, stamp)
end, 500)

