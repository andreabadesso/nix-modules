# Andre's Nix Modules

A collection of my personal Nix/home-manager modules, built for reusability across machines.

## Available Modules

### Neovim (`programs.andrevim`)

Full-featured Neovim configuration with LSP, treesitter, and modern plugin setup.

**Features:**
- LSP support (TypeScript, Lua, Nix, Python, etc.)
- Blink.cmp for completion
- Treesitter for syntax highlighting
- Telescope for fuzzy finding
- Neo-tree + Oil for file management
- Harpoon for quick file switching
- Git integration (fugitive, gitsigns, diffview)
- Claude Code integration
- Obsidian Aurora theme

## Usage

### As a Flake Input

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    andrenix = {
      url = "path:/Users/andrecardoso/.config/nvim-flake";
      # Or from GitHub: url = "github:yourusername/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, andrenix, ... }: {
    # Your config here
  };
}
```

### Import Individual Modules

```nix
{ inputs, ... }:
{
  imports = [
    inputs.andrenix.homeManagerModules.neovim
  ];

  programs.andrevim.enable = true;
}
```

### Standalone Package

Run neovim directly without home-manager:

```bash
nix run github:yourusername/nvim-flake#neovim
# Or locally:
nix run /Users/andrecardoso/.config/nvim-flake#neovim
```

## Module Structure

```
nvim-flake/
├── flake.nix                    # Flake definition
├── modules/
│   ├── default.nix              # Module exports
│   └── neovim/
│       ├── default.nix          # Home-manager module
│       └── config/              # Lua configuration
└── packages/
    ├── default.nix
    └── neovim.nix               # Standalone package
```

## Future Modules

This repo is designed to be extensible. Planned additions:
- `tmux` - Tmux configuration with Obsidian Aurora theme
- `shell` - Zsh/Bash setup with custom prompt
- `git` - Git config with aliases and delta

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
