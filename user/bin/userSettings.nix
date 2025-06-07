{ config, ... }:
{
	config = {
		user.settings = {
			username = "fulcrum";
			displayName = "Fulcrum";

			emailAddresses.git = "dragon.fighter@outlook.de";
		};

		packages = {
			defaults = {
				browser.active = "zen";
				explorer.active = "nautilus";
				editor.active = "sublime";
				terminal.active = "kitty";
				shell.active = "zsh";
			};
		};
	};

}