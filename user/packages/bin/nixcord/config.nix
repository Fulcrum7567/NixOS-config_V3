{ config, lib, inputs, ... }:
{
  config = lib.mkIf config.packages.nixcord.enable {
		system.inputUpdates = [ "nixcord" ];

    home-manager.users.${config.user.settings.username} = {
      imports = [
				inputs.nixcord.homeModules.nixcord
			];

      programs.nixcord = {
        enable = true;
      };
    };
  };
}