{
  description = "Development environment for terraform-google-github-identity";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.terraform ];
        };
      in
      {
        packages = {
          inherit (pkgs) google-cloud-sdk;

          terraform = pkgs.terraform_1.withPlugins (p: [
            p.google
          ]);
        };

        devShells.default = pkgs.mkShell {
          packages = [
            self.packages.${system}.google-cloud-sdk
            self.packages.${system}.terraform
          ];
        };

        checks.validate = pkgs.stdenvNoCC.mkDerivation {
          name = "terraform-google-github-identity-validate";
          __impure = true;

          src = let
            inherit (pkgs) nix-gitignore;

            root = ./.;
            patterns = nix-gitignore.withGitignoreFile extraIgnores root;
            extraIgnores = [
              "/nix/"
              "*.nix"
              "flake.lock"
              "/.github/"
              ".vscode/"
              "result"
              "result-*"
            ];
          in builtins.path {
            name = "terraform-google-github-identity-source";
            path = root;
            filter = nix-gitignore.gitignoreFilterPure (_: _: true) patterns root;
          };

          nativeBuildInputs = [ self.packages.${system}.terraform ];

          buildPhase = ''
            terraform init
            terraform validate
          '';

          installPhase = ''
            touch $out
          '';
        };
      }
    ) // {
      overlays = import nix/overlays;
    };
}
