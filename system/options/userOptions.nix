{ lib, ... }:
{

	options.user.settings = {

		# Username
		username = lib.mkOption {
			type = lib.types.string;
			isRequired = true;
			description = "Set the username of your profile.";
			example = "fulcrum";
		};


		# Display name
		displayName = lib.mkOption {
			type = lib.types.string;
			isRequired = true;
			description = "Set the display name of your profile.";
			example = "Fulcrum";
		};


		# Emails
		emailAddresses = {
			git = lib.mkOption {
				type = lib.types.string;
				description = "Set the email address for git";
			};
		};

		# Git
		git = {
			username = lib.mkOption {
				type = lib.types.string;
				default = options.user.settings.displayName;
				description = "Set the username for git";
			};
			userEmail = lib.mkOption {
				type = lib.types.string;
				default = options.user.settings.emailAddresses.git;
			};
		};

	};
	


}