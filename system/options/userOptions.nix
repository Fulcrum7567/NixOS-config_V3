{ lib, config, ... }:
{

	options.user.settings = {

		# Username
		username = lib.mkOption {
			type = lib.types.str;
			description = "Set the username of your profile.";
			example = "fulcrum";
		};


		# Display name
		displayName = lib.mkOption {
			type = lib.types.str;
			description = "Set the display name of your profile.";
			example = "Fulcrum";
		};


		# Emails
		emailAddresses = {
			git = lib.mkOption {
				type = lib.types.str;
				description = "Set the email address for git";
			};
		};

		# Git
		git = {
			username = lib.mkOption {
				type = lib.types.str;
				default = config.user.settings.displayName;
				description = "Set the username for git";
			};
			userEmail = lib.mkOption {
				type = lib.types.str;
				default = config.user.settings.emailAddresses.git;
			};
		};

	};
	


}