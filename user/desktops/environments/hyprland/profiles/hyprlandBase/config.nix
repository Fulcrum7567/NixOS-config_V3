{ config, lib, pkgs, hyprland, ... }:
{
	config = lib.mkIf config.desktopEnvironments.hyprland.hyprlandBase.enable {
		programs.hyprland = {
			enable = true;
			package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
			portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
		};

		environment.sessionVariables = {
			NIXOS_OZONE_WL = "1";
		};

		home-manager.users.${config.user.settings.username} = {
			wayland.windowManager.hyprland = {
				enable = true;
				package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
				portalPackage = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;

				settings = {
					xwayland.force_zero_scaling = 1;
				};
			};
		};

		nix.settings = {
			substituters = ["https://hyprland.cachix.org"];
			trusted-substituters = ["https://hyprland.cachix.org"];
			trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
		};

		desktopEnvironments.hyprland.bin = {
			feel.enable = true;
			gestures.enable = true;
			input.enable = true;
			bindings.enable = true;

			apps = {
				waybar = {
					enable = true;
					activeConfig = "slyHarvey";
				};
				rofi.enable = true;
			};
		};

		theming = {
			useStylix = true;
			wallpaper.diashow.selectCommand = "";
		};

		
	};
}