local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    -- Prettier for the whole JS/TS family. It used to be eslint_d for .js and
    -- prettier for .ts, which formatted the two halves of a codebase
    -- differently for no reason.
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    nix = { "nixpkgs_fmt" },
    elixir = { "mix" },
    heex = { "mix" },
    sh = { "shfmt" },
    bash = { "shfmt" },
  },

  default_format_opts = {
    lsp_format = "fallback",
  },

  -- Format on save, but only where the project actually declares a formatter
  -- config. Otherwise saving a file in someone else's repo reformats it to
  -- your defaults and buries your change in noise.
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return nil
    end

    local ft = vim.bo[bufnr].filetype
    -- Always safe: these read config from the file/tree itself or have one
    -- canonical style.
    local always = { lua = true, nix = true, elixir = true, heex = true, python = true }
    if always[ft] then
      return { timeout_ms = 1500 }
    end

    -- Prettier-family: only if the project ships a prettier config.
    local found = vim.fs.find(
      { ".prettierrc", ".prettierrc.json", ".prettierrc.js", ".prettierrc.yaml",
        ".prettierrc.yml", "prettier.config.js", "prettier.config.mjs", ".editorconfig" },
      { upward = true, path = vim.api.nvim_buf_get_name(bufnr) }
    )
    if #found > 0 then
      return { timeout_ms = 1500 }
    end
    return nil
  end,
})

-- Manual format — still the escape hatch when format_on_save declines.
vim.keymap.set({ "n", "v" }, "<leader>fm", function()
  conform.format({ async = false, timeout_ms = 2000 })
end, { desc = "Format file or range" })

-- Toggle autoformat, buffer-local with `!` or global without.
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = "Disable format-on-save (! = this buffer only)", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = "Re-enable format-on-save" })

vim.keymap.set("n", "<leader>uf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end, { desc = "Toggle format on save" })
