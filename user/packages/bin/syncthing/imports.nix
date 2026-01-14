{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, currentHost, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings currentHost; })
	    (import ./options.nix { inherit lib config settings currentHost; })
	    (import ./package.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings currentHost; })
  	];
}