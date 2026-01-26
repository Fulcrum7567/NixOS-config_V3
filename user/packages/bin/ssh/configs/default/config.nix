{ config, lib, settings, pkgs-default, pkgs-stable, pkgs-unstable, ... }:
let
	option = config.packages.${settings.optionName};
in
{
	config = lib.mkIf (option.enable && (option.activeConfig == "default")) {

		systemd.services.prevent-sleep-on-ssh = {
			description = "Inhibit suspend when SSH connections are active";
			wantedBy = [ "multi-user.target" ];
			after = [ "network.target" "sshd.service" ];
			
			# We need 'ss' (from iproute2) to check connections and 'systemd-inhibit' (from systemd)
			path = [ pkgs-default.iproute2 pkgs-default.systemd pkgs-default.bash ];

			script = ''
				# The port your SSHD listens on (usually 22)
				SSH_PORT=22

				while true; do
					# Check for established connections where the source port is our SSH port
					# -H: no header, -t: tcp, -n: numeric
					COUNT=$(ss -Htn sport = :$SSH_PORT | wc -l)

					if [ "$COUNT" -gt 0 ]; then
						echo "Active SSH connection detected ($COUNT). Inhibiting suspend..."
						
						# Engage the lock.
						# The command inside 'bash -c' runs continuously until connections drop to 0.
						# Once that internal loop finishes, systemd-inhibit exits and releases the lock.
						systemd-inhibit \
							--what=sleep \
							--why="Active SSH session" \
							--mode=block \
							bash -c "while [ \"\$(ss -Htn sport = :$SSH_PORT | wc -l)\" -gt 0 ]; do sleep 5; done"
							
						echo "SSH connections closed. Suspend lock released."
					fi

					# Check again in 10 seconds
					sleep 10
				done
			'';

			serviceConfig = {
				User = "root";
				Restart = "always";
				RestartSec = "5s";
			};
		};

		home-manager.users.${config.user.settings.username} = {
			
		};
	};
} 
