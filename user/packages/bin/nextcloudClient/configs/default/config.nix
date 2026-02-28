{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
	username = config.user.settings.username;
	syncDir = "/home/${username}/Nextcloud";
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

	# Script that dehydrates (frees local space for) files not accessed
	# in the last 30 days. In VFS suffix mode, dehydrating means replacing
	# the real file with a 0-byte placeholder named <file>.nextcloud.
	# The Nextcloud client picks this up on the next sync cycle.
	#
	# Respects pinned files: checks the sync database's "flags" table
	# where pinState=1 means "AlwaysLocal" (user chose "Make always
	# available locally"). Files inside pinned folders are also skipped.
	dehydrateScript = pkgs-default.writeShellScript "nextcloud-dehydrate-old" ''
		set -euo pipefail
		SYNC_DIR="${syncDir}"
		DAYS=30
		SQLITE="${pkgs-default.sqlite}/bin/sqlite3"

		[ -d "$SYNC_DIR" ] || exit 0

		# Find the sync database
		SYNC_DB=$(${pkgs-default.findutils}/bin/find "$SYNC_DIR" -maxdepth 1 -name '.sync_*.db' -not -name '*-shm' -not -name '*-wal' | head -1)
		if [ -z "$SYNC_DB" ] || [ ! -f "$SYNC_DB" ]; then
			echo "No sync database found, skipping."
			exit 0
		fi

		# Copy the database so we don't conflict with the running client.
		# We must copy the WAL and SHM files too, otherwise recent pin
		# state changes that haven't been checkpointed are lost.
		TMP_DIR=$(${pkgs-default.coreutils}/bin/mktemp -d /tmp/nc_sync.XXXXXX)
		TMP_DB="$TMP_DIR/sync.db"
		trap "${pkgs-default.coreutils}/bin/rm -rf $TMP_DIR" EXIT
		${pkgs-default.coreutils}/bin/cp "$SYNC_DB" "$TMP_DB"
		[ -f "''${SYNC_DB}-wal" ] && ${pkgs-default.coreutils}/bin/cp "''${SYNC_DB}-wal" "''${TMP_DB}-wal"
		[ -f "''${SYNC_DB}-shm" ] && ${pkgs-default.coreutils}/bin/cp "''${SYNC_DB}-shm" "''${TMP_DB}-shm"

		# Query all pinned paths (pinState=1 = AlwaysLocal)
		# These are relative paths from the sync root
		PINNED_PATHS=$($SQLITE "$TMP_DB" "SELECT path FROM flags WHERE pinState = 1;" 2>/dev/null || true)

		is_pinned() {
			local rel_path="$1"
			for pinned in $PINNED_PATHS; do
				# Exact match (file is pinned directly)
				if [ "$rel_path" = "$pinned" ]; then
					return 0
				fi
				# File is inside a pinned folder
				case "$rel_path" in
					"$pinned"/*) return 0 ;;
				esac
			done
			return 1
		}

		${pkgs-default.findutils}/bin/find "$SYNC_DIR" \
			-type f \
			-mtime +''${DAYS} \
			-not -name '*.nextcloud' \
			-not -name '.sync_*' \
			-not -name '.nextcloudsync.*' \
			-not -name '.csync_journal.*' \
			-not -path '*/.stfolder/*' \
			-not -path '*/.stversions/*' \
			-print0 \
		| while IFS= read -r -d "" file; do
			# Get path relative to sync dir for database lookup
			rel_path="''${file#$SYNC_DIR/}"

			# Skip pinned files and files inside pinned folders
			if is_pinned "$rel_path"; then
				echo "Skipped (pinned): $rel_path"
				continue
			fi

			# Create a 0-byte placeholder with .nextcloud suffix
			placeholder="''${file}.nextcloud"
			${pkgs-default.coreutils}/bin/truncate -s 0 "$placeholder"
			${pkgs-default.coreutils}/bin/touch -r "$file" "$placeholder"
			${pkgs-default.coreutils}/bin/rm -f "$file"
			echo "Dehydrated: $rel_path"
		done
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

			# Automatically free local space for files not accessed in 30+ days.
			# Runs daily and converts them to cloud-only VFS placeholders.
			systemd.user.services.nextcloud-dehydrate = {
				Unit = {
					Description = "Dehydrate Nextcloud files not accessed in 30+ days";
				};
				Service = {
					Type = "oneshot";
					ExecStart = "${dehydrateScript}";
				};
			};
			systemd.user.timers.nextcloud-dehydrate = {
				Unit = {
					Description = "Daily timer to dehydrate old Nextcloud files";
				};
				Timer = {
					OnCalendar = "daily";
					Persistent = true;       # Run on next boot if missed
					RandomizedDelaySec = "1h"; # Avoid running at exact midnight
				};
				Install = {
					WantedBy = [ "timers.target" ];
				};
			};

			# Mask the D-Bus activation service that causes Nextcloud to
			# instantly relaunch whenever you try to close it. The file manager
			# queries the CloudProviders D-Bus name, which triggers a restart.
			/*
			xdg.dataFile."dbus-1/services/com.nextcloudgmbh.Nextcloud.service".text = ''
				[D-BUS Service]
				Name=com.nextcloudgmbh.Nextcloud
				Exec=/bin/false
			'';
			*/
		};

	};
} 
