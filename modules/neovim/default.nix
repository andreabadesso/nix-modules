{ nixpkgs-unstable }:
{ config, pkgs, lib, ... }:

let
  cfg = config.programs.andrevim;

  pkgs-unstable = import nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  opencode-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "opencode.nvim";
    version = "2024-11-07";
    src = pkgs.fetchFromGitHub {
      owner = "NickvanDyke";
      repo = "opencode.nvim";
      rev = "main";
      sha256 = "sha256-wVZYTjvr9eN5RXiDnqq+t4rtozjqiMv15tRnKaQy9YU=";
    };
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
        lua-language-server
        nil
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.prettier
        nodePackages.eslint_d
        stylua
        black
        nixpkgs-fmt
        ripgrep
      ];

      plugins = with pkgs.vimPlugins; [
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
        opencode-nvim
      ];

      extraLuaConfig = builtins.readFile ./config/init.lua;
    };
  };
}
