{
  description = "Modern and clean Gtk theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
      };

    in {
      packages.${system}.default =
        pkgs.callPackage ./nix/default.nix {};
    };
}
