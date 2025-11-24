{ lib, config,  inputs, pkgs-default, pkgs-stable, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config inputs settings pkgs-default pkgs-stable; })
	    (import ./options.nix { inherit lib config settings; })
			./config.nix
  	];
}