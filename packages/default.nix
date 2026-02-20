{ pkgs, pkgs-unstable }:
{
  neovim = import ./neovim.nix { inherit pkgs pkgs-unstable; };
}
