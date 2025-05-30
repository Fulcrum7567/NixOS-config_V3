{ inputs, config, lib, pkgs, ... }:
{
	options.theming.plymouth.mikuboot.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
		description = "Whether to enable mikuboot plymouth.";
	};

	imports = [
			inputs.mikuboot.nixosModules.default
	];

	config = lib.mkIf config.theming.plymouth.mikuboot.enable {

		boot.plymouth = {
			enable = true;

			themePackages = [ pkgs.mikuboot ];
			theme = "mikuboot";
		};
	};

}