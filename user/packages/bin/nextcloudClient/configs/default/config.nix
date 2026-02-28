{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
	username = config.user.settings.username;
	configFile = "/home/${username}/.config/Nextcloud/nextcloud.cfg";

	# Script that patches VFS settings into the Nextcloud config.
	# We patch rather than overwrite because Nextcloud stores account
	# credentials and sync state in the same file.
	patchVfsScript = pkgs-default.writeShellScript "nextcloud-patch-vfs" ''
		set -euo pipefail
		CFG="${configFile}"
		SED="${pkgs-default.gnused}/bin/sed"

		[ -f "$CFG" ] || exit 0

		# Enable VFS globally
		$SED -i 's/^isVfsEnabled=false/isVfsEnabled=true/' "$CFG"

		# Enable experimental options (needed for VFS UI on Linux)
		if grep -q '^showExperimentalOptions=' "$CFG"; then
			$SED -i 's/^showExperimentalOptions=false/showExperimentalOptions=true/' "$CFG"
		else
			$SED -i '/^\[General\]/a showExperimentalOptions=true' "$CFG"
		fi

		# Switch any folder from plain sync to VFS suffix mode
		$SED -i 's/^virtualFilesMode=off/virtualFilesMode=suffix/' "$CFG"
	'';
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		home-manager.users.${username} = {
			# Run the VFS patch script before Nextcloud starts on every login.
			# This ensures VFS stays enabled even if Nextcloud resets the flag.
			systemd.user.services.nextcloud-patch-vfs = {
				Unit = {
					Description = "Patch Nextcloud config to enable Virtual Files (VFS)";
					Before = [ "com.nextcloud.desktopclient.nextcloud.service" ];
				};
				Service = {
					Type = "oneshot";
					ExecStart = "${patchVfsScript}";
					RemainAfterExit = true;
				};
				Install = {
					WantedBy = [ "default.target" ];
				};
			};

			# Mask the D-Bus activation service that causes Nextcloud to
			# instantly relaunch whenever you try to close it. The file manager
			# queries the CloudProviders D-Bus name, which triggers a restart.
			xdg.dataFile."dbus-1/services/com.nextcloudgmbh.Nextcloud.service".text = ''
				[D-BUS Service]
				Name=com.nextcloudgmbh.Nextcloud
				Exec=/bin/false
			'';
		};

	};
} 
