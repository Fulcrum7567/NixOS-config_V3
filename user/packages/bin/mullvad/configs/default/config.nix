{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		# Graphical package
		services.mullvad-vpn.package = pkgs-default.mullvad-vpn;

		home-manager.users.${config.user.settings.username} = {
			programs.mullvad-vpn = {
				enable = true;
				settings = {
					animateMap = true;
					autoConnect = option.autoEnableDelay == 0;
					browsedForSplitTunnelingApplications = [ ];
					changelogDisplayedForVersion = "";
					enableSystemNotifications = true;
					monochromaticIcon = false;
					preferredLocale = "system";
					startMinimized = false;
					unpinnedWindow = true;
					updateDismissedForVersion = "";
				};
			};
		};


		# Auto enable

		systemd.services.mullvad-connect-delayed = lib.mkIf (option.autoEnableDelay > 0) {
			description = "Connect to Mullvad VPN after a set delay";

			wantedBy = [ "multi-user.target" ];

			after = [ "network-online.target" "mullvad-daemon.service" ];
			wants = [ "network-online.target" "mullvad-daemon.service" ];

			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;

				ExecStart = ''
					${pkgs-default.bash}/bin/bash -c "(sleep ${toString option.autoEnableDelay} && ${pkgs-default.mullvad-vpn}/bin/mullvad connect) &"
				'';
			};
		};
	};
} 
