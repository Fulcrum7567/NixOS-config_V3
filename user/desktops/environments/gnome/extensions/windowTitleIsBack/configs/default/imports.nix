{ lib, config, settings, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config settings; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
