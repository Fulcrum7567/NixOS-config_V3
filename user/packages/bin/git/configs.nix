{ config, lib, ... }:
{
	config = lib.mkIf config.packages.git.enable {
		
		home-manager.users.${config.user.settings.username} = { lib, ... }: {
			programs.git = {
				enable = true;
				settings = {
					user = {
						name = config.user.settings.git.username;
						email = config.user.settings.git.userEmail;
					};

					credential = lib.mkIf config.packages.git.storeCredentials {
						helper = "store";
					};
				};
			};	

		};
	};
} 
