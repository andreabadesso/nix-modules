-- Language servers are managed through Nix (see nvim.nix extraPackages)
local servers = {
  ts_ls = {
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
        },
      },
    },
  },
  -- eslint LSP not available in nixpkgs - using eslint_d via conform.nvim instead
  jsonls = {},
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT'
        },
        diagnostics = {
          globals = {'vim'},
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  nil_ls = {}, -- Nix LSP
}

-- Get capabilities from blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()

local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true, buffer=bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
  -- Fixed: [d goes to previous, ]d goes to next
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>rf', '<cmd>Telescope lsp_references<cr>', opts)
  -- Code actions
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  -- Toggle inlay hints
  vim.keymap.set('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
  end, { buffer = bufnr, desc = "Toggle inlay hints" })

  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
end

local function setup(server)
  local server_opts = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, servers[server] or {})

  require("lspconfig")[server].setup(server_opts)
end

-- Setup all servers directly since they're managed by Nix
for server, server_opts in pairs(servers) do
  if server_opts then
    setup(server)
  end
end

-- Load snippets for blink.cmp
require('luasnip.loaders.from_vscode').lazy_load()

-- Setup blink.cmp (modern completion)
require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide' },
    ['<C-y>'] = { 'select_and_accept' },
    ['<CR>'] = { 'accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
  },
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  cmdline = {
    enabled = false, -- Disable cmdline completion
  },
  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = {
      border = 'rounded',
      draw = {
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
      window = { border = 'rounded' },
    },
    ghost_text = { enabled = true },
  },
  signature = {
    enabled = true,
    window = { border = 'rounded' },
  },
  snippets = {
    expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
    active = function(filter)
      if filter and filter.direction then
        return require('luasnip').jumpable(filter.direction)
      end
      return require('luasnip').in_snippet()
    end,
    jump = function(direction) require('luasnip').jump(direction) end,
  },
})
