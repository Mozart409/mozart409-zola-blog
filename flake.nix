{
  description = "Development environment for a Zola project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ] (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [rust-overlay.overlays.default];
      };
      rust = pkgs.rust-bin.stable."1.94.0".default;

      isLinux = pkgs.stdenv.isLinux;
      isDarwin = pkgs.stdenv.isDarwin;

      commonPackages = with pkgs; [
        # keep-sorted start
        cocogitto
        git
        just
        keep-sorted
        lazydocker
        lefthook
        tailwindcss_4
        zola
        # keep-sorted end
      ];

      linuxPackages = with pkgs; [
        opencode
      ];

      darwinPackages = with pkgs; [
      ];
    in {
      # to use other shells, run:
      # nix develop . --command fish
      devShells.default = pkgs.mkShell {
        buildInputs =
          commonPackages
          ++ pkgs.lib.optionals isLinux linuxPackages
          ++ pkgs.lib.optionals isDarwin darwinPackages;
        shellHook = ''
          lefthook install
          cog install-hook
        '';
      };
    });
}
