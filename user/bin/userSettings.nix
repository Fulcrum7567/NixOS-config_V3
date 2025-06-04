{ config, ... }:
{
	config = {
		user.settings = {
			username = "fulcrum";
			displayName = "Fulcrum";

			emailAddresses.git = "dragon.fighter@outlook.de";
		};

		defaults = {
			browser = {
				enable = true;
				active = "zen";
			};
			explorer = {
				enable = true;
				active = "nautilus";
			};
		};
	};

}