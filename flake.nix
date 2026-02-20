{
  description = "Andre's Nix modules collection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      # Individual home-manager modules (can import just one)
      homeManagerModules = import ./modules;

      # Standalone packages
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        import ./packages { inherit pkgs pkgs-unstable; }
      );
    };
}
