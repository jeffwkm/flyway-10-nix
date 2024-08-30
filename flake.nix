{
  description = "flyway-10 package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
  };

  outputs = _inputs@{ nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        flyway = (args: pkgs.callPackage ./flyway.nix args);
      in rec {
        packages = {
          flyway = flyway { };
          flyway-postgres = flyway {
            suffix = "postgres";
            driversGlob = "postgres*";
          };
        };
        overlays = { default = (final: prev: packages); };
      });
}
