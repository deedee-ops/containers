{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      pre-commit-hooks,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          excludes = [ ".direnv" ];

          hooks = {
            check-case-conflicts.enable = true;
            check-executables-have-shebangs.enable = true;
            check-merge-conflicts.enable = true;
            check-shebang-scripts-are-executable.enable = true;
            end-of-file-fixer.enable = true;
            fix-byte-order-marker.enable = true;
            mixed-line-endings.enable = true;
            trim-trailing-whitespace.enable = true;

            deadnix.enable = true;
            flake-checker.enable = true;
            statix.enable = true;
            nixfmt-rfc-style.enable = true;

            check-json.enable = true;
            hadolint.enable = true;
            shellcheck = {
              enable = true;
              excludes = [ ".*\.zsh" ];
            };
            yamllint.enable = true;

            actionlint.enable = true;
            commitizen.enable = true;
          };
        };

        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;

          buildInputs = [
            pkgs.cue
            pkgs.dgoss
            pkgs.go-task
            pkgs.jq
          ] ++ self.checks.${system}.pre-commit-check.enabledPackages;
        };
      }
    );
}
