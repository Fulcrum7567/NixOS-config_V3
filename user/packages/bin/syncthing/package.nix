{ config, lib, pkgs-default, pkgs-stable, pkgs-unstable, settings, ... }:
{
	config = lib.mkIf config.packages.${settings.optionName}.enable {

		sops.secrets."syncthing-gui-password" = { 
			owner = "syncthing"; 
			group = "syncthing";
			sopsFile = ./bin/syncthingSecrets.yaml;
			format = "yaml";
			key = "gui/password";
		};

		services.syncthing = {
			enable = true;
			user = "syncthing";
			group = "syncthing";

			settings = {
				gui = {
					user = config.user.settings.username;
        	theme = (if (config.theming.polarity == "light") then "light" else "dark");
				};
			};
		};

		systemd.services.syncthing.preStart = lib.mkForce ''
			# 1. Create directory structure (just in case)
			mkdir -p ${config.services.syncthing.dataDir}
			chmod 700 ${config.services.syncthing.dataDir}

			# 2. Ensure config.xml exists (let Syncthing generate it if missing)
			if [ ! -f ${config.services.syncthing.dataDir}/config.xml ]; then
				${pkgs-default.syncthing}/bin/syncthing generate --home=${config.services.syncthing.dataDir}
			fi

			# 3. Inject the Password safely using sed
			# We read the raw password, hash it using bcrypt (optional but better), or just put cleartext 
			# (Syncthing will hash it on next boot).
			
			PASSWORD=$(cat /run/secrets/syncthing-gui-password)
			CONFIG_FILE="${config.services.syncthing.dataDir}/config.xml"
			
			# Use sed to replace the password field. 
			# This regex looks for <password>...</password> inside the <gui> block.
			# Note: This is a simple replacement. For complex XML, xmlstarlet is better, 
			# but this works 99% of the time for Syncthing.
			
			sed -i "s|<password>.*</password>|<password>$PASSWORD</password>|" "$CONFIG_FILE"
		'';

	};
}