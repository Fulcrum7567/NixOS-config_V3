{ lib, config, ... }:
{
	imports = [
	    ./polarity.nix
	    ./cursor.nix
	    ./stylix.nix
	    ./wallpaper.nix
			./options.nix
			./accentColor.nix
  	];
}