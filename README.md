# Ops Tool Belt, Nix Edition
The goal of this repo is to provide a fast mechanism to deploy the standard ops cli tool set on your laptop. This repo makes use of the Nix Package Manager, which can be used on Mac and on Linux (including WSL). How do you use this repo?

1. Install nix package manager as per the instructions at https://nixos.org/download.html#nix-install-macos
1. enable nix flakes and experimental tooling. Follow the instructions at https://nixos.wiki/wiki/Flakes#Permanent You may need to re-login or reboot for the changes take effect.
1. Run `nix profile install .` to install the packages.

# Sharp Edges
The Nix Package Manager does things a bit differently than homebrew or other package managers. This can cause surprising behavior for the uninitiated.

  * Nix is an overloaded term which can refer to:
    1. The Nix package manager.
    1. The Nix language (used to describe packages and build systems)
    1. The OS (actually called NixOS)
  * Nix uses symlinks heavily to manage packages. In your home directory, you will notice that `~/.nix-profile` is a link to nix managed profiles in `/nix/var/nix/profiles/per-user/`.
  * All packages and binaries are installed in `/nix/store` and linked to from your profile as needed.
  * The language used to define the nix build process, packages, and list of packages is a turing complete, functional language vaguely related to Haskel. This means it can be difficult to read and more difficult to write. There are lots of examples and templates on the internet though for many use cases, so you may  be able to get by with a very basic primer like the one at https://nixos.org/guides/nix-language.html .
  * Recently, the Nix community developed a new way of interacting with Nix Package manager called "nix flakes". Much like the conversion from Python2 to Python3, it has caused division in the community and it has caused some trouble with the documentation. Our use of the Nix Package Manager relies on these new Nix Flakes. Because flakes are "experimental" (even though they've been around for 2+ years), the official documentation is light on Flakes material.

# Nice Things About Nix
Nix has many features which offset some of the Sharp Edges.

  * There are more than 80,000 packages in the nix package repository (called nixpkgs). Whatever package you are looking for is probably there if it is available in homebrew or apt or dnf. There are also a lot of non-free packages in the repo. https://search.nixos.org/packages is a convenient search utility for exploring available Nix packages.
  * Nix can produce repeatable builds of software. When you use flakes, a `flake.lock` file is created which pins versions to a specific commit. This means when you pass around a flake to your peers, they can be assured that they are using the same version of software as you, built in the same way with the same set of dependencies.
  * Nix allows you to roll back. When you install, remove, or modify packages, Nix keeps track of every action (with symlinks). You can use `nix profile history` to see all of the changes to your system. You can use `nix profile rollback` to go back to the previous revision or an arbitrary revision.
  * If you go all-in on NixOS, you can define all of the behavior of your system in one file. You can also use [home-manager](https://github.com/nix-community/home-manager) to control all of your dot-files and personal lists of packages. With flakes, you could put all of this configuration into one file (or group of imported files), which can be checked into source control.