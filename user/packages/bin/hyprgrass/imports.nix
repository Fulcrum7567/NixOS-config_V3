{ lib, config, pkgs-default, pkgs, pkgs-stable, pkgs-unstable, hyprgrass, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings hyprgrass; })
	    (import ./options.nix { inherit lib config settings; })
	    (import ./package.nix { inherit lib config pkgs pkgs-default pkgs-stable pkgs-unstable settings hyprgrass; })
  	];
}