{ pkgs, pkgs-unstable }:

let
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

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
    inherit plugins;
    customRC = ''
      luafile ${./config/init.lua}
    '';
  };
in
pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig // {
  wrapperArgs = neovimConfig.wrapperArgs ++ [
    "--prefix" "PATH" ":" (pkgs.lib.makeBinPath extraPackages)
    "--set" "XDG_CONFIG_HOME" (pkgs.symlinkJoin {
      name = "andrevim-config";
      paths = [
        (pkgs.writeTextDir "nvim/init.lua" (builtins.readFile ./config/init.lua))
        (pkgs.symlinkJoin {
          name = "nvim-lua";
          paths = [ (pkgs.runCommand "nvim-lua-config" {} ''
            mkdir -p $out/nvim/lua
            cp -r ${./config/lua}/* $out/nvim/lua/
          '') ];
        })
      ];
    })
  ];
})
