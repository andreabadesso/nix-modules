-- Language servers are installed by Nix (see modules/neovim/default.nix
-- `extraPackages`); their *definitions* (cmd, root_markers, filetypes) come
-- from nvim-lspconfig's `lsp/` directory. This file only layers settings and
-- keymaps on top, via the native vim.lsp.config API (Neovim 0.11+).

-- ── Diagnostics ─────────────────────────────────────────────────────────────
-- Neovim 0.11 ships with virtual_text OFF by default, so an unconfigured setup
-- surfaces errors only in the sign column. Make them visible and sorted.
vim.diagnostic.config({
  severity_sort = true,
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = {
    spacing = 2,
    prefix = "●",
    severity = { min = vim.diagnostic.severity.WARN },
  },
  float = {
    source = true,
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

-- ── Capabilities ────────────────────────────────────────────────────────────
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, 'blink.cmp')
if has_blink then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Applies to every server, including ones enabled by a plugin rather than here.
vim.lsp.config('*', { capabilities = capabilities })

-- ── Buffer-local keymaps ────────────────────────────────────────────────────
-- LspAttach is the supported hook in 0.11+. A per-server `on_attach` silently
-- skips any server this file doesn't configure by hand.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('andrevim_lsp_attach', { clear = true }),
  callback = function(ev)
    local bufnr = ev.buf
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map('n', 'gd', vim.lsp.buf.definition, "Go to definition")
    map('n', 'gD', vim.lsp.buf.declaration, "Go to declaration")
    map('n', 'gi', vim.lsp.buf.implementation, "Go to implementation")
    map('n', 'gT', vim.lsp.buf.type_definition, "Go to type definition")
    map('n', 'K', vim.lsp.buf.hover, "Hover docs")
    map('i', '<C-k>', vim.lsp.buf.signature_help, "Signature help")

    map('n', '<leader>rn', vim.lsp.buf.rename, "Rename symbol")
    map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, "Code action")
    map('n', '<leader>rf', '<cmd>Telescope lsp_references<cr>', "References")
    map('n', '<leader>vws', vim.lsp.buf.workspace_symbol, "Workspace symbols")

    -- Diagnostics. `vim.diagnostic.goto_prev`/`goto_next` are deprecated as of
    -- 0.11 and slated for removal; `jump` is the replacement.
    map('n', '<leader>vd', vim.diagnostic.open_float, "Line diagnostics")
    map('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
    map('n', '[e', function()
      vim.diagnostic.jump({ count = -1, float = true, severity = vim.diagnostic.severity.ERROR })
    end, "Previous error")
    map('n', ']e', function()
      vim.diagnostic.jump({ count = 1, float = true, severity = vim.diagnostic.severity.ERROR })
    end, "Next error")

    map('n', '<leader>ih', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr }
      )
    end, "Toggle inlay hints")

    -- Highlight the other references to the symbol under the cursor.
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight') then
      local hl_group = vim.api.nvim_create_augroup('andrevim_lsp_highlight', { clear = false })
      vim.api.nvim_clear_autocmds({ group = hl_group, buffer = bufnr })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = hl_group,
        buffer = bufnr,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

-- ── Per-server settings ─────────────────────────────────────────────────────
local ts_inlay_hints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
}

vim.lsp.config('ts_ls', {
  settings = {
    typescript = { inlayHints = ts_inlay_hints },
    javascript = { inlayHints = ts_inlay_hints },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim', 'Snacks' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      hint = { enable = true },
      telemetry = { enable = false },
    },
  },
})

-- `expert` is the Elixir language server. It has no nvim-lspconfig definition,
-- so the full config (cmd/filetypes/root_markers) has to live here.
vim.lsp.config('expert', {
  cmd = { 'expert', '--stdio' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { 'mix.exs' },
})

-- html/cssls/eslint/jsonls all come out of vscode-langservers-extracted, which
-- was already being installed but only half used.
vim.lsp.enable({
  'ts_ls',
  'jsonls',
  'html',
  'cssls',
  'eslint',
  'lua_ls',
  'nil_ls',
  'expert',
})

-- ── Completion ──────────────────────────────────────────────────────────────
require('luasnip.loaders.from_vscode').lazy_load()

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
    nerd_font_variant = 'mono',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  cmdline = {
    enabled = false,
  },
  completion = {
    accept = {
      auto_brackets = { enabled = true },
    },
    menu = {
      draw = {
        columns = { { 'label', 'label_description', gap = 1 }, { 'kind_icon', 'kind' } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = { enabled = true },
  },
  signature = {
    enabled = true,
  },
  -- The `luasnip` preset wires expand/jump/active for us; the hand-rolled
  -- versions this replaces got `active` subtly wrong (ignored the filter).
  snippets = {
    preset = 'luasnip',
  },
})
