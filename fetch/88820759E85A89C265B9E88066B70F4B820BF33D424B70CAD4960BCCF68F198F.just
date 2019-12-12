# Variables

ssh_user := "root"
systems_file := "deploy.nix"

# Commands

default:
	just update
	just update-pkgs
	just deploy
	home-manager switch -I nixpkgs=/etc/nixos/nixos-config/sources/links/nixos-unstable
	nix-env -u '*' -I nixpkgs=/etc/nixos/nixos-config/sources/links/nixos-unstable

build glob="*":
	cd deployments; \
	morph build "{{systems_file}}" --on="{{glob}}" --keep-result

deploy glob="*":
	cd deployments; \
	morph deploy "{{systems_file}}" switch --on="{{glob}}" --keep-result

secrets glob="*":
	cd deployments; \
	morph upload-secrets "{{systems_file}}" --on="{{glob}}"

update:
	./sources/update.sh

update-pkgs:
	parallel --bar update-nix-fetchgit ::: pkgs/*/*.nix

rebuild command nixpkgs="/etc/nixos/nixos-config/sources/links/nixos-unstable":
	nixos-rebuild "{{command}}" -I "nixpkgs={{nixpkgs}}"

# Export

export SSH_USER := ssh_user
export NIX_PATH := ""
