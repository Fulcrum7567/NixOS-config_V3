{ config, lib, ... }:
let
	settings = import ./settings.nix;
in
{
	imports = [
		(import ./configs/importer.nix { inherit lib config settings; })
		(import ./options.nix { inherit config lib settings; })
	];	
} 
