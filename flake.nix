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
      let pkgs = import nixpkgs { inherit system; };
      in rec {
        packages = { flyway = pkgs.callPackage ./flyway.nix { }; };
        overlays = { default = (final: prev: { flyway = packages.flyway; }); };
      });
}
