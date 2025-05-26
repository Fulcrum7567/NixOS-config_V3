{ config, lib, ... }:
{
	config = lib.mkIf config.packages.git.enable {
		
		home-manager.users.${config.user.settings.username} = { lib, ... }: {
			programs.git = {
				enable = true;
				userName = config.user.settings.git.username;
				userEmail = config.user.settings.git.userEmail;
				extraConfig = lib.mkIf config.packages.git.storeCredentials {
					credential.helper = "store";
				};
			};	

		};
	};
} 
