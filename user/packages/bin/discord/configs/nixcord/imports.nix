{ lib, config, settings, inputs, ... }:
{
	imports = [
		(import ./config.nix { inherit lib config inputs settings; })
		(import ./options.nix { inherit lib config settings; })
	];
} 
