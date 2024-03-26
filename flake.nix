{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.cue
              pkgs.dgoss
              pkgs.goss
              pkgs.go-task
              pkgs.jq
              pkgs.lefthook

              # linters
              pkgs.hadolint
              pkgs.shellcheck
              pkgs.yamllint
            ];
          };
        }
      );
}
