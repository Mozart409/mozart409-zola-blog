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
        lazydocker
        lefthook
        cocogitto
        just
        playwright-driver.browsers
        git
        zola
        tailwindcss_4
      ];

      linuxPackages = with pkgs; [
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
          export COMPOSE_BAKE=true
          export PLAYWRIGHT_BROWSERS_PATH=${pkgs.playwright-driver.browsers}
          export PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS=true

          lefthook install
          cog install-hook
        '';
      };
    });
}
