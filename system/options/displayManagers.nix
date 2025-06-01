{ config, lib, ... }:
{
	options.displayManagers = {
		activeDisplayManager = lib.mkOption {
			type = lib.types.str;
			description = "Set the active display manager. Must exist in user/desktop/displayManagers.";
		};

		isDisplayManagerActive = lib.mkOption {
			type = lib.types.bool;
			default = false;
			description = "Option to check whether a valid display manager was selected. Is beeing set by the display manager.";
		};
	};

	# Warning
	config = lib.mkIf (config.displayManagers.isDisplayManagerActive == false) {
		warnings = [
			"No valid display manager is set! This surely causes trouble if you want to see something else than the terminal."
		];
	};
}