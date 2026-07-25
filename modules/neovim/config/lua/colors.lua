vim.cmd.colorscheme("tokyonight-night")

-- Let the terminal's own background (Ghostty's Obsidian Aurora + blur) show
-- through instead of painting tokyonight's over it.
local function transparent()
  for _, group in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "TelescopeNormal",
    "TelescopeBorder",
    "NeoTreeNormal",
    "NeoTreeNormalNC",
  }) do
    vim.api.nvim_set_hl(0, group, { bg = "none" })
  end
end

transparent()

-- Re-apply whenever a colorscheme is loaded again (plugins do this).
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("andrevim_transparent", { clear = true }),
  callback = transparent,
})
