{
  description = "systemd-nspawn images with NixOS";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    imports = [
      inputs.treefmt-nix.flakeModule
    ];

    perSystem = { config, system, ... }: {
      packages.default =
        let
          nixos = inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./configuration.nix
              ./nspawn-tarball.nix
            ];
          };
        in
        nixos.config.system.build.tarball;

      treefmt.config = {
        projectRootFile = "flake.nix";
        programs = {
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;
          shfmt.enable = true;
          shellcheck.enable = true;
        };
      };
    };
  };
}
