-- On NixOS, parsers are managed by Nix, so disable auto-installation
require'nvim-treesitter.configs'.setup {
  -- Parsers are handled by Nix configuration, so this list is mainly for reference
  -- The actual parsers are installed via nixpkgs.vimPlugins.nvim-treesitter.withPlugins
  ensure_installed = {},

  -- Disable automatic installation since parsers are managed by Nix
  sync_install = false,
  auto_install = false,

  highlight = {
    enable = true,
    disable = function(_, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 650
    end,

    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  -- Treesitter textobjects for smart selections
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj
      keymaps = {
        -- Function textobjects
        ["af"] = { query = "@function.outer", desc = "Select around function" },
        ["if"] = { query = "@function.inner", desc = "Select inside function" },
        -- Class textobjects
        ["ac"] = { query = "@class.outer", desc = "Select around class" },
        ["ic"] = { query = "@class.inner", desc = "Select inside class" },
        -- Parameter/argument textobjects
        ["aa"] = { query = "@parameter.outer", desc = "Select around argument" },
        ["ia"] = { query = "@parameter.inner", desc = "Select inside argument" },
        -- Block textobjects
        ["ab"] = { query = "@block.outer", desc = "Select around block" },
        ["ib"] = { query = "@block.inner", desc = "Select inside block" },
        -- Conditional textobjects
        ["ai"] = { query = "@conditional.outer", desc = "Select around conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "Select inside conditional" },
        -- Loop textobjects
        ["al"] = { query = "@loop.outer", desc = "Select around loop" },
        ["il"] = { query = "@loop.inner", desc = "Select inside loop" },
        -- Comment textobjects
        ["a/"] = { query = "@comment.outer", desc = "Select around comment" },
      },
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@class.outer'] = 'V',
      },
      include_surrounding_whitespace = true,
    },
    move = {
      enable = true,
      set_jumps = true, -- Whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = { query = "@function.outer", desc = "Next function start" },
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
      },
      goto_next_end = {
        ["]M"] = { query = "@function.outer", desc = "Next function end" },
        ["]["] = { query = "@class.outer", desc = "Next class end" },
      },
      goto_previous_start = {
        ["[m"] = { query = "@function.outer", desc = "Previous function start" },
        ["[["] = { query = "@class.outer", desc = "Previous class start" },
        ["[a"] = { query = "@parameter.inner", desc = "Previous argument" },
      },
      goto_previous_end = {
        ["[M"] = { query = "@function.outer", desc = "Previous function end" },
        ["[]"] = { query = "@class.outer", desc = "Previous class end" },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next argument" },
      },
      swap_previous = {
        ["<leader>A"] = { query = "@parameter.inner", desc = "Swap with previous argument" },
      },
    },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },
}

-- Fix for neotest: Set parser directory so child processes can find Nix-managed parsers
local parser_install_dir = vim.fn.stdpath("data") .. "/nix-treesitter-parsers"
vim.fn.mkdir(parser_install_dir, "p")

-- Create symlinks to Nix parsers for neotest child processes
local parser_path = vim.api.nvim_get_runtime_file("parser", false)[1]
if parser_path then
  vim.fn.system(string.format("ln -sfn %s/* %s/", parser_path, parser_install_dir))
end

-- Add to parser path
vim.opt.runtimepath:append(parser_install_dir)

