# example

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flyway.url = "github:jeffwkm/flyway-10-nix";
    flyway.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = flake-utils.lib.eachDefaultSystem (system:
    let flypkgs = inputs.flyway.packages.${system};
        flyway = flypkgs.flyway;
        # flyway = flypkgs.flyway-postgres;
    in {
      # ...
    }
  );
}
```
