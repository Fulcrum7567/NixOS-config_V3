{ lib, config, pkgs-default, pkgs-stable, pkgs-unstable, nvf, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings nvf; })
	    (import ./options.nix { inherit lib config settings; })
	    (import ./package.nix { inherit lib config pkgs-default pkgs-stable pkgs-unstable settings nvf; })
  	];
}