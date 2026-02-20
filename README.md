# Andre's Nix Modules

A collection of my personal Nix/home-manager modules, built for reusability across machines.

## Available Modules

### Neovim (`programs.andrevim`)

Full-featured Neovim configuration with LSP, treesitter, and modern plugin setup.

**Features:**
- LSP support (TypeScript, Lua, Nix, Python, etc.) using native `vim.lsp.config` (Neovim 0.11+)
- Blink.cmp for completion
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- Neo-tree + Oil for file management
- Harpoon for quick file switching
- Git integration (fugitive, gitsigns, diffview)
- Claude Code integration
- Obsidian Aurora theme

### Tmux

Tmux configuration with vim-style navigation and Obsidian Aurora theme.

**Features:**
- Obsidian Aurora themed status bar
- Vim keybindings for pane navigation
- Auto-resize bindings (HJKL)
- Window swapping (Ctrl+Shift+H/L)
- Tmux-sessionizer integration (bound to `prefix + f`)
- Plugins: sensible, resurrect, continuum, yank

### Git

Git configuration with delta and sensible defaults.

**Features:**
- Delta for improved diffs
- Global gitignore (Linux, macOS, Emacs, Vim)
- Useful aliases (`log`, `show`, `blame`)
- LFS support
- Signing can be configured per-host

### Shell

Zsh + prezto configuration with Obsidian Aurora prompt.

**Features:**
- Obsidian Aurora themed prompt with git status
- Prezto modules: environment, history, completion, syntax-highlighting
- McFly for fuzzy history search
- Auto-starts tmux on shell login
- Vim keybindings
- Directory shortcuts (`~dev`, `~myio`, `~hathor`)

## Usage

### As a Flake Input

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-modules = {
      url = "github:yourusername/nix-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-modules, ... }: {
    # Your config here
  };
}
```

### Import Individual Modules

```nix
{ inputs, ... }:
{
  imports = [
    inputs.nix-modules.homeManagerModules.neovim
    inputs.nix-modules.homeManagerModules.tmux
    inputs.nix-modules.homeManagerModules.git
    inputs.nix-modules.homeManagerModules.shell
  ];

  programs.andrevim.enable = true;
  
  # Configure git signing per-host
  programs.git.signing = {
    key = "YOUR_GPG_KEY";
    signByDefault = true;
  };
}
```

### Standalone Package

Run neovim directly without home-manager:

```bash
nix run github:yourusername/nix-modules#neovim
```

## Module Structure

```
nix-modules/
├── flake.nix                    # Flake definition
├── modules/
│   ├── default.nix              # Module exports
│   ├── neovim/                  # Neovim configuration
│   │   ├── default.nix
│   │   └── config/
│   ├── tmux/                    # Tmux configuration
│   │   └── default.nix
│   ├── git/                     # Git configuration
│   │   └── default.nix
│   └── shell/                   # Shell configuration
│       └── default.nix
└── packages/
    ├── default.nix
    └── neovim.nix               # Standalone package
```

## Theme: Obsidian Aurora

All modules share a consistent dark theme:

- **Background:** `#0d1117` (deep obsidian)
- **Foreground:** `#c9d1d9` (soft silver)
- **Blue:** `#58a6ff` (electric blue)
- **Green:** `#7ee787` (aurora green)
- **Purple:** `#bc8cff` (lavender)

## Development

```bash
# Test the flake
nix flake check

# Build the neovim package
nix build .#neovim

# Update dependencies
nix flake update
```

## License

Personal configuration - use as reference or fork freely.
