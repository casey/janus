# Variables

ssh_user := "root"
systems_file := "deploy.nix"
nix_path := "nixpkgs=/etc/nixos/links/nixpkgs"

# Commands

build +machines:
	parallel -j1 --ungroup ./files/deploy.sh '{}' build ::: {{machines}}

deploy +machines:
	parallel -j1 --ungroup ./files/deploy.sh '{}' switch ::: {{machines}}

secrets:
	just secrets/default

update:
	nix flake update
	sh ./files/link.sh

update-pkgs:
	parallel --timeout 60 --bar update-nix-fetchgit ::: pkgs/*/*.nix

# Export

export SSH_USER := ssh_user
export NIX_PATH := ""
