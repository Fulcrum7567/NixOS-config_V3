{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, waybar, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings; })
	    (import ./bin/imports.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings; })
	    (import ./options.nix { inherit lib config settings; })
	    (import ./package.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings waybar; })
  	];
}