{ inputs, config, lib, pkgs, ... }:
{
	options.theming.plymouth.mikuboot.enable = lib.mkOption {
		type = lib.types.bool;
		default = false;
		description = "Whether to enable mikuboot plymouth.";
	};

	config = lib.mkIf config.theming.plymouth.mikuboot.enable {

		imports = [
			inputs.mikuboot.nixosModules.default
		];

		boot.plymouth = {
			enable = true;

			themePackages = [ pkgs.mikuboot ];
			theme = "mikuboot";
		};
	};

}