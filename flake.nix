# This flake will install several command line tools
# used by ops. How do I use this file you ask?
# 1. Install nix package manager as per the instructions
#    at https://nixos.org/download.html#nix-install-macos
# 2. enable nix flakes and experimental tooling. Follow
#    the instructions at https://nixos.wiki/wiki/Flakes#Permanent
#    You may need to re-login or reboot for the changes take
#    effect.
# 3. Run `nix profile install .` to install the packages.

{
  description = "ops tool belt";

  # We use the latest nixpkgs release as well as an external
  # flakes utility tool set as inputs.
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  
  outputs = { self, nixpkgs, flake-utils, ... }:
    # eachDefaultSystem allows us to use this under Darwin and linux
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
          hsp-bosh-cli = pkgs.bosh-cli.overrideAttrs (oldAttrs: rec {
            version = oldAttrs.version;
            postPatch = ''
            substituteInPlace cmd/version.go --replace '[DEV BUILD]' 'hsdp-${version}'
            substituteInPlace vendor/github.com/cloudfoundry/config-server/types/certificate_generator.go --replace '(365' '(1095'
          '';
          });
      in {
        packages = {
          # default must be set to a "derivation".
          default = self.packages.${system}.stdPkgs;
          # buildEnv is just a convenient derivation container
          # for a list of packages.
          stdPkgs = pkgs.buildEnv {
            name = "Ops Tools";
            paths = with pkgs; [
              awscli2
              bats
              hsp-bosh-cli
              cloudfoundry-cli
              direnv
              dos2unix
              fzf
              gawk
              getopt
              git
              git-lfs
              gnupg
              htop
              jq
              kubectl
              nmap
              pwgen
              ripgrep
              terraform
              tree
              wget
              yq
            ];
          };
          # If you desire a set of personalized packages,
          # you can create a new flake in a diferent
          # directory following the patern of this file,
          # or you can add a section here following the
          # pattern of the "stdPkgs" section named something
          # like "myPkgs" for uh... your packages. You can
          # then install with "nix profile install .#myPkgs"
        };
      }
    );
}
