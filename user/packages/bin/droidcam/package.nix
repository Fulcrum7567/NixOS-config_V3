{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		environment.systemPackages = with pkgs-default; [
			(droidcam.overrideAttrs (oldAttrs: {
				postInstall = (oldAttrs.postInstall or "") + ''
					# Use sed to replace the Exec line in the desktop file
					# We wrap the original command with systemd-inhibit
					sed -i 's|^Exec=droidcam|Exec=${systemd}/bin/systemd-inhibit --what=idle:sleep:handle-lid-switch --who="DroidCam" --why="Streaming" droidcam|' $out/share/applications/droidcam.desktop
				'';
			}))
			v4l-utils
		];
	};
}