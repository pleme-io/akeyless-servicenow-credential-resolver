{
  description = "ServiceNow MID external credential resolver using Akeyless HTTP API";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    substrate = {
      url = "github:pleme-io/substrate";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, substrate, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      mkJavaMavenPackage = (import "${substrate}/lib/java-maven.nix").mkJavaMavenPackage;
    in {
      packages.default = mkJavaMavenPackage pkgs {
        pname = "akeyless-servicenow-credential-resolver";
        version = "0.0.0-dev";
        src = self;
        mvnHash = ""; # requires nix build to compute
        description = "ServiceNow MID external credential resolver using Akeyless HTTP API";
        homepage = "https://github.com/pleme-io/akeyless-servicenow-credential-resolver";
      };

      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [ jdk17 maven ];
      };
    });
}
