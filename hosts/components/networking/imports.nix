{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, sops-nix, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings sops-nix; })
	    (import ./options.nix { inherit lib config settings; })
  	];
}