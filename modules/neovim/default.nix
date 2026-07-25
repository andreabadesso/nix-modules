{ config, pkgs, lib, nixpkgs-unstable, ... }:

let
  cfg = config.programs.andrevim;

  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

in
{
  options.programs.andrevim = {
    enable = lib.mkEnableOption "Andre's neovim configuration";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim/lua" = {
      source = ./config/lua;
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;

      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      vimAlias = true;
      viAlias = true;

      extraPackages = with pkgs; [
        tree-sitter
        gcc
        nodejs
        ripgrep
        fd # telescope/snacks use it for file listing when present

        # ── Language servers ──
        lua-language-server
        nil
        nodePackages.typescript-language-server
        # Provides html, cssls, jsonls *and* eslint — all four are enabled in
        # lua/plugins/lsp.lua.
        nodePackages.vscode-langservers-extracted
        elixir
        erlang

        # ── Formatters (see lua/plugins/conform.lua) ──
        nodePackages.prettier
        nodePackages.eslint_d
        stylua
        black
        nixpkgs-fmt
        shfmt
      ];

      plugins = with pkgs.vimPlugins; [
        # lua/plugins/lsp.lua drives servers through the native vim.lsp.config
        # API, but that API still resolves each server's cmd/root_markers from
        # nvim-lspconfig's `lsp/` directory. This was only ever present as a
        # transitive dependency of typescript-nvim — if that plugin were
        # dropped, every LSP would have silently stopped starting.
        nvim-lspconfig
        fidget-nvim
        blink-cmp
        luasnip
        friendly-snippets
        (nvim-treesitter.withPlugins (p: [
          p.vimdoc
          p.typescript
          p.tsx
          p.javascript
          p.lua
          p.python
          p.nix
          p.swift
          p.json
          p.yaml
          p.toml
          p.bash
          p.markdown
          p.html
          p.css
          p.elixir
          p.heex
        ]))
        nvim-treesitter-context
        nvim-treesitter-textobjects
        typescript-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        neo-tree-nvim
        oil-nvim
        nvim-web-devicons
        vim-tmux-navigator
        harpoon2
        flash-nvim
        vim-gh-line
        vim-fugitive
        gitsigns-nvim
        diffview-nvim
        dressing-nvim
        trouble-nvim
        which-key-nvim
        noice-nvim
        nui-nvim
        lualine-nvim
        nvim-surround
        nvim-autopairs
        conform-nvim
        neotest
        nvim-nio
      ] ++ [
        pkgs-unstable.vimPlugins.neotest-jest
        toggleterm-nvim
        tokyonight-nvim
        undotree
        plenary-nvim
        nvim-coverage
        snacks-nvim
        render-markdown-nvim
        pkgs-unstable.vimPlugins.claudecode-nvim
      ];

      extraLuaConfig = builtins.readFile ./config/init.lua;
    };
  };
}
