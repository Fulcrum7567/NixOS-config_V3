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
				explorer.active = "nemo";
				editor.active = "sublime";
				terminal.active = "ghostty";
				shell.active = "zsh";
			};
		};
	};

}