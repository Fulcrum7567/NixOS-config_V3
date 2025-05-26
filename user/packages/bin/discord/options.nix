{ config, lib, ... }:
{
	options.packages.discord = {
		enable = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Whether to enable discord.";
		};

		variation = lib.mkOption {
			type = lib.types.enum [
				"vanilla"
				"betterdiscord"
				"nixcord"
			];
			default = "nixcord";
			description = "Type of the discord installation.";
		};
	};
} 
