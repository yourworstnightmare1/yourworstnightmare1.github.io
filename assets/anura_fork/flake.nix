{
  description = "Rust example flake for Zero to Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; overlays = [ (import rust-overlay) ]; };
      });
    in
    {
      devShells = forAllSystems
        ({ pkgs }: {
          default = (pkgs.mkShell.override {
            stdenv = pkgs.llvmPackages.stdenv;
          }) {
            buildInputs = [
              (pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
              pkgs.nodejs_18
              pkgs.jre
              pkgs.pkgsi686Linux.glibc
              pkgs.llvmPackages.bintools-unwrapped
              pkgs.inotify-tools
            ];
          };
        });
    };
}
