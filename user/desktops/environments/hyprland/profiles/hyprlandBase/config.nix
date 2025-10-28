{ config, lib, pkgs, hyprland, ... }:

with lib;

let
	# A reference to your custom option for display configurations.
  cfg = config.hardware.displays;

  # Helper function to convert a display's attribute set into the string format
  # that Hyprland's 'monitor' setting expects.
  # The format is: monitor=name,resolution@refreshRate,position,scale
  # We assume a default scale of 1, as it's not defined in your option.
  formatDisplay = display:
    "${display.name},${display.resolution}@${toString display.refreshRate},${display.position},1";

  # 1. Get all defined displays as a list from the attribute set (attrsOf).
  allDisplays = attrValues cfg;

  # 2. Filter the list to include only those that are enabled.
  enabledDisplays = filter (display: display.enable) allDisplays;

  # 3. Find the display that is explicitly marked as the primary one.
  #    `findFirst` returns `null` if no primary display is set.
  primaryDisplay = findFirst (display: display.primary) null enabledDisplays;

  # 4. Create a list of all other enabled displays (non-primary).
  #    This is done to prevent duplicating the primary monitor in the final list.
  otherDisplays = filter (display: !display.primary) enabledDisplays;

  # 5. Build the final list of monitor configuration strings for Hyprland.
  #    If a primary display is set, it will be placed first in the list.
  #    This is a common convention for ensuring it's treated as the main display.
  monitorConfig =
    if primaryDisplay != null then
      # Prepend the formatted primary display to the list of other displays.
      [ (formatDisplay primaryDisplay) ] ++ (map formatDisplay otherDisplays)
    else
      # If no primary is set, just format all enabled displays in their default order.
      map formatDisplay enabledDisplays;
in
{
	config = lib.mkIf config.desktopEnvironments.hyprland.hyprlandBase.enable {
		system.inputUpdates = [ "hyprland-unstable" "hyprland-stable" ];
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

					monitor = monitorConfig;

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
				hyprpaper.enable = true;
			};
		};

		theming = {
			useStylix = true;
		};

		packages = {
			hypridle.enable = true;
			mako.enable = true;
		};

		desktops.sessionType = "wayland";

		
	};
}