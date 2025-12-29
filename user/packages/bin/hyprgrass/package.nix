{ config, lib, pkgs, pkgs-default, pkgs-stable, pkgs-unstable, settings, hyprgrass, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		home-manager.users.${config.user.settings.username} = {
			wayland.windowManager.hyprland = {
				plugins = [
						hyprgrass.packages.${config.host.settings.system}.default
						# optional integration with pulse-audio, see examples/hyprgrass-pulse/README.md
						# inputs.hyprgrass.packages.${pkgs.system}.hyprgrass-pulse
				];
			};
		};
	};
}