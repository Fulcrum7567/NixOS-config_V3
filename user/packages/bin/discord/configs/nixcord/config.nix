{ config, lib, settings, inputs, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {
		home-manager.users.${config.user.settings.username} = {
			imports = lib.mkIf (config.packages.discord.variation == "nixcord") [
				inputs.nixcord.homeModules.nixcord
			];
		};
	};
} 
