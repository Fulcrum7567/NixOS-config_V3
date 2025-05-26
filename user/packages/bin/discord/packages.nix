{ config, lib, pkgs-default, inputs, ... }:
{
	config = lib.mkIf config.packages.discord.enable {

		home-manager.users.${config.user.settings.username} = { config, lib, inputs, ... }: {

			imports = lib.mkIf (config.packages.discord.variation == "nixcord") [
				inputs.nixcord.homeModules.nixcord
			];

		};


		environment.systemPackages = with pkgs-default; [

		];
	};
} 
