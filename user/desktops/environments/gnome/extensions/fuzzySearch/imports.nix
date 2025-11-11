{ lib, config, pkgs, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
	    (import ./configs/importer.nix { inherit lib config settings; })
	    (import ./options.nix { inherit lib config settings; })
	    (import ./package.nix { inherit lib config pkgs settings; })
  	];
}