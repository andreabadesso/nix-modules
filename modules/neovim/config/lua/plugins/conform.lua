require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    javascript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    nix = { "nixpkgs_fmt" },
  },
  -- format_on_save disabled - use <leader>fm to manually format
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
})

-- Keybinding for manual formatting
vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  require("conform").format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file or range" })
