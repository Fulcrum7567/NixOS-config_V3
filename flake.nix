{

	description = "Fulcrum's NixOS config V3";



	# ╔══════════════════════════════════════════════════════════════╗
	# ║                                                              ║
	# ║    ooOoOOo o.     O OooOOo.  O       o oOoOOoOOo .oOOOo.     ║
	# ║       O    Oo     o O     `O o       O     o     o     o     ║
	# ║       o    O O    O o      O O       o     o     O.          ║
	# ║       O    O  o   o O     .o o       o     O      `OOoo.     ║
	# ║       o    O   o  O oOooOO'  o       O     o           `O    ║
	# ║       O    o    O O o        O       O     O            o    ║
	# ║       O    o     Oo O        `o     Oo     O     O.    .O    ║
	# ║    ooOOoOo O     `o o'        `OoooO'O     o'     `oooO'     ║
	# ║                                                              ║
	# ╚══════════════════════════════════════════════════════════════╝

	inputs = {

		# SYSTEM

		# Input nixpkgs
		nixpkgs-stable.url = "nixpkgs/nixos-25.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";


		# Input home-manager
		home-manager-stable = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};
		
		home-manager-unstable = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};


		# Sops-nix
		sops-nix-unstable = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		sops-nix-stable = {
			url = "github:Mic92/sops-nix";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};	


		# Stylix

		stylix-stable = {
			url = "github:nix-community/stylix/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};

		stylix-unstable = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		nix-colors.url = "github:misterio77/nix-colors";

		# Hyprland
		hyprland-unstable = {
			url = "github:hyprwm/hyprland";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		hyprland-stable = {
			url = "github:hyprwm/hyprland";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};

		hyprgrass-stable = {
			url = "github:horriblename/hyprgrass";
			inputs.hyprland.follows = "hyprland-stable";
		};

		hyprgrass-unstable = {
			url = "github:horriblename/hyprgrass";
			inputs.hyprland.follows = "hyprland-unstable";
		};
		# Chaotic's Nyx
		chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

		disko-unstable = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		disko-stable = {
			url = "github:nix-community/disko";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};

		nixos-anywhere = {
			url = "github:nix-community/nixos-anywhere";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
			inputs.disko.follows = "disko-unstable";
		};

		waybar.url = "github:Alexays/Waybar";

		noctalia-stable = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

		noctalia-unstable = {
			url = "github:noctalia-dev/noctalia-shell";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};


		

		# ╔════════════════════════════════╗
		# ║                                ║
		# ║                                ║
		# ║                                ║
		# ║    .oOoO' .oOo. .oOo. .oOo     ║
		# ║    O   o  O   o O   o `Ooo.    ║
		# ║    o   O  o   O o   O     O    ║
		# ║    `OoO'o oOoO' oOoO' `OoO'    ║
		# ║           O     O              ║
		# ║           o'    o'             ║
		# ║                                ║
		# ╚════════════════════════════════╝

		# Nixcord
		nixcord.url = "github:KaylorBen/nixcord";


		# Zen-browser
		zen-browser-stable = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};

		zen-browser-unstable = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

		mikuboot.url = "gitlab:evysgarden/mikuboot";

		nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/00e11463876a04a77fb97ba50c015ab9e5bee90d";

		flatpak.url = "github:gmodena/nix-flatpak";

		nvf-stable = {
			url = "github:NotAShelf/nvf";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};

		nvf-unstable = {
			url = "github:NotAShelf/nvf";
			inputs.nixpkgs.follows = "nixpkgs-unstable";
		};

	};


	outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager-stable, home-manager-unstable, sops-nix-stable, sops-nix-unstable, nixcord, zen-browser-stable, zen-browser-unstable, mikuboot, stylix-stable, stylix-unstable, nix-vscode-extensions, flatpak, nvf-stable, nvf-unstable, hyprland-stable, hyprland-unstable, chaotic, disko-stable, disko-unstable, hyprgrass-stable, hyprgrass-unstable, waybar, noctalia-stable, noctalia-unstable, nixos-anywhere, ... }:
	let

		# ╔═══════════════════════════════════════════════════════════╗
		# ║                                                           ║
		# ║                                    o     o                ║
		# ║                         o         O     O                 ║
		# ║                                   O     o                 ║
		# ║                                   o     O                 ║
		# ║    `o   O .oOoO' `OoOo. O  .oOoO' OoOo. o  .oOo. .oOo     ║
		# ║     O   o O   o   o     o  O   o  O   o O  OooO' `Ooo.    ║
		# ║     o  O  o   O   O     O  o   O  o   O o  O         O    ║
		# ║     `o'   `OoO'o  o     o' `OoO'o `OoO' Oo `OoO' `OoO'    ║
		# ║                                                           ║
		# ╚═══════════════════════════════════════════════════════════╝

		

		# Create a list of all directories inside of ./hosts/hosts
		# Every directory represents a host configuration
		hosts = builtins.filter (x: x != null) (
			nixpkgs-stable.lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (
				builtins.readDir ./hosts/hosts
			)
		);

		# Function to generate configuration for a single host
		mkHost = host:
			let
				hostSettings = (import ./hosts/hosts/${host}/hostSettingsRaw.nix);
				currentHost = host;


				# ╔═══════════════════════════════╗
				# ║                               ║
				# ║          o                    ║
				# ║          O                    ║
				# ║          o                    ║
				# ║          o                    ║
				# ║    .oOo. O  o  .oOoO .oOo     ║
				# ║    O   o OoO   o   O `Ooo.    ║
				# ║    o   O o  O  O   o     O    ║
				# ║    oOoO' O   o `OoOo `OoO'    ║
				# ║    O               O          ║
				# ║    o'           OoO'          ║
				# ║                               ║
				# ╚═══════════════════════════════╝

				pkgs-stable = import nixpkgs-stable {
					system = hostSettings.system;
					config = {
						allowUnfree = true;
						allowUnfreePredicate = (_: true);
						allowInsecure = true;
						permittedInsecurePackages = [ "openssl-1.1.1w" ];
						nvidia.acceptLicense = true;
					};
					overlays = [
						nix-vscode-extensions.overlays.default
						(import ./system/customTypes/overlay.nix)
					];
				};

				pkgs-unstable = import nixpkgs-unstable {
					system = hostSettings.system;
					config = {
						allowUnfree = true;
						allowUnfreePredicate = (_: true);
						allowInsecure = true;
						permittedInsecurePackages = [ "openssl-1.1.1w" ];
						nvidia.acceptLicense = true;
					};
					overlays = [
						nix-vscode-extensions.overlays.default
						chaotic.overlays.default
						(import ./system/customTypes/overlay.nix)
					];
				};

				pkgs-default = (if (hostSettings.defaultPackageState == "stable")
								then
									pkgs-stable
								else
									pkgs-unstable
								);

				pkgs-system = (if (hostSettings.systemState == "stable")
								then
									pkgs-stable
								else
									pkgs-unstable
								);

				
				lib = (if (hostSettings.systemState == "stable")
						then
							nixpkgs-stable.lib
						else
							nixpkgs-unstable.lib
						);

				libExtended = (if (hostSettings.systemState == "stable")
						then
							pkgs-stable.lib
						else
							pkgs-unstable.lib
						);

				home-manager = (if (hostSettings.systemState == "stable")
								then
									home-manager-stable
								else
									home-manager-unstable
								);


				stylix = (if (hostSettings.systemState == "stable")
								then
									stylix-stable
								else
									stylix-unstable
								);

				sops-nix = (if (hostSettings.systemState == "stable")
								then
									sops-nix-stable
								else
									sops-nix-unstable
								);



				zen-browser = (if (hostSettings.defaultPackageState == "stable")
							then
								zen-browser-unstable
							else
								zen-browser-unstable
					);

				nvf = (if (hostSettings.defaultPackageState == "stable")
							then
								nvf-stable
							else
								nvf-unstable
					);

				noctalia = (if (hostSettings.defaultPackageState == "stable")
							then
								noctalia-stable
							else
								noctalia-unstable
					);
				
				hyprland = (if (hostSettings.defaultPackageState == "stable")
							then
								hyprland-stable
							else
								hyprland-unstable
					);

				hyprgrass = (if (hostSettings.defaultPackageState == "stable")
							then
								hyprgrass-stable
							else
								hyprgrass-unstable
					);

				nyx-modules = if (hostSettings.systemState == "unstable") then [
					chaotic.nixosModules.default
				] else [
					chaotic.nixosModules.nyx-cache
					chaotic.nixosModules.nyx-overlay
					chaotic.nixosModules.nyx-registry
				];

				disko = (if (hostSettings.systemState == "stable")
							then
								disko-stable
							else
								disko-unstable
					);
			in
			{
				name = host;
				value = lib.nixosSystem {
					system = hostSettings.system;
					modules = [
						# Home Manager as a NixOS module
						home-manager.nixosModules.home-manager
						{
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;

							imports = [
								inputs.nix-colors.homeManagerModules.default
							];
						}

						# Stylix
						stylix.nixosModules.stylix
						# Sops-nix
						sops-nix.nixosModules.sops


						# Options
						./system/options/hostOptions.nix
						./system/options/userOptions.nix
						./system/options/themeOptions.nix
						./system/options/displayManagers.nix
						./system/options/desktopOptions.nix
						./system/options/shortcuts.nix
						./system/options/hardware.nix
						./system/options/systemOptions.nix

						# Scripts
						./system/scripts/updateInputs.nix
						./system/scripts/setup-sops.nix

						# Host
						./hosts/hosts/${host}/hostConfigs/configuration.nix
						./hosts/hosts/${host}/hostSettings.nix
						./hosts/components/importer.nix
						./hosts/fixes/importer.nix
						./hosts/hosts/${host}/quickFixes.nix

						# Server
						./server/system/filesystem/imports.nix
						./server/services/importer.nix

						# User
						./user/bin/user.nix
						./user/bin/userSettings.nix
						./user/bin/var.nix
						./user/bin/home.nix
						
						# Theming
						./user/themes/bin/importer.nix
						./user/themes/bin/apps/importer.nix
						./user/themes/profiles/importer.nix

						# Desktop
						./user/desktops/displayManagers/importer.nix
						./user/desktops/environments/importer.nix
						./user/desktops/profiles/importer.nix

						# Packages
						./user/packages/bin/importer.nix
						./user/packages/defaults/importer.nix
						./user/packages/groups/importer.nix
					] ++ nyx-modules;

					specialArgs = {
						inherit currentHost self inputs pkgs-default pkgs-stable pkgs-unstable zen-browser nvf hyprland hyprgrass disko sops-nix waybar noctalia;
						hostSettingsRaw = hostSettings;
						lib = libExtended;
					};
				};
			};

	in
	{


		# ╔════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
		# ║                                                                                                                                ║
		# ║    .oOOOo.  o       O .oOOOo.  oOoOOoOOo o.OOoOoo Oo      oO                                                                   ║
		# ║    o     o  O       o o     o      o      O       O O    o o                                                                   ║
		# ║    O.       `o     O' O.           o      o       o  o  O  O                                                                   ║
		# ║     `OOoo.    O   o    `OOoo.      O      ooOO    O   Oo   O                                                                   ║
		# ║          `O    `O'          `O     o      O       O        o ooooooooo                                                         ║
		# ║           o     o            o     O      o       o        O                                                                   ║
		# ║    O.    .O     O     O.    .O     O      O       o        O                                                                   ║
		# ║     `oooO'      O      `oooO'      o'    ooOooOoO O        o                                                                   ║
		# ║     .oOOOo.   .oOOOo.  o.     O OOooOoO ooOoOOo  .oOOOo.  O       o `OooOOo.     Oo    oOoOOoOOo ooOoOOo  .oOOOo.  o.     O    ║
		# ║    .O     o  .O     o. Oo     o o          O    .O     o  o       O  o     `o   o  O       o        O    .O     o. Oo     o    ║
		# ║    o         O       o O O    O O          o    o         O       o  O      O  O    o      o        o    O       o O O    O    ║
		# ║    o         o       O O  o   o oOooO      O    O         o       o  o     .O oOooOoOo     O        O    o       O O  o   o    ║
		# ║    o         O       o O   o  O O          o    O   .oOOo o       O  OOooOO'  o      O     o        o    O       o O   o  O    ║
		# ║    O         o       O o    O O o          O    o.      O O       O  o    o   O      o     O        O    o       O o    O O    ║
		# ║    `o     .o `o     O' o     Oo o          O     O.    oO `o     Oo  O     O  o      O     O        O    `o     O' o     Oo    ║
		# ║     `OoooO'   `OoooO'  O     `o O'      ooOOoOo   `OooO'   `OoooO'O  O      o O.     O     o'    ooOOoOo  `OoooO'  O     `o    ║
		# ║                                                                                                                                ║
		# ╚════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝


		# Generate a nixosConfiguration for every host in ./hosts/hosts
		nixosConfigurations = builtins.listToAttrs (
			map mkHost hosts
		);

		apps."x86_64-linux".install-server = {
			type = "app";
			program = toString (nixpkgs-unstable.legacyPackages."x86_64-linux".writeShellScript "install-server" ''
				PATH=${nixpkgs-unstable.legacyPackages."x86_64-linux".coreutils}/bin:${nixpkgs-unstable.legacyPackages."x86_64-linux".util-linux}/bin:${nixpkgs-unstable.legacyPackages."x86_64-linux".openssh}/bin:${nixpkgs-unstable.legacyPackages."x86_64-linux".nix}/bin:${nixpkgs-unstable.legacyPackages."x86_64-linux".git}/bin:${nixpkgs-unstable.legacyPackages."x86_64-linux".gnused}/bin:${nixpkgs-unstable.legacyPackages."x86_64-linux".gnugrep}/bin:$PATH
				
				if [ ! -f "flake.nix" ]; then
					echo "Error: Please run this command from the root of your dotfiles repository."
					exit 1
				fi

				echo "╔════════════════════════════════╗"
				echo "║   Fulcrum Server Installer     ║"
				echo "╚════════════════════════════════╝"
				echo ""

				# 0. Host Selection
				HOST_NAME=""
				while [ -z "$HOST_NAME" ]; do
					read -p "[?] Enter Host Configuration Name (e.g. Server): " INPUT_HOST
					if [ -n "$INPUT_HOST" ]; then
						if [ ! -d "./hosts/hosts/$INPUT_HOST" ]; then
							echo "[!] Warning: Directory ./hosts/hosts/$INPUT_HOST does not exist."
							read -p "    Continue anyway? [y/N] " CONFIRM
							if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
								HOST_NAME="$INPUT_HOST"
							fi
						else
							HOST_NAME="$INPUT_HOST"
						fi
					fi
				done

				# 1. ISO Creation
				echo ""
				read -p "[?] Do you need to build a headless installer ISO? [y/N] " BUILD_ISO
				if [ "$BUILD_ISO" = "y" ] || [ "$BUILD_ISO" = "Y" ]; then
					echo "[*] Creating iso.nix..."
					cat > iso.nix <<EOF
{ pkgs, modulesPath, lib, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  users.users.root.password = "nixos";
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";
}
EOF
					echo "[*] Building ISO..."
					nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
					
					ISO_PATH=$(readlink -f result/iso/*.iso)
					echo ""
					echo "[✓] ISO Ready: $ISO_PATH"
					
					read -p "[?] Flash ISO to USB now? [y/N] " FLASH_ISO
					if [ "$FLASH_ISO" = "y" ] || [ "$FLASH_ISO" = "Y" ]; then
						echo "[*] Listing block devices:"
						lsblk -d -o NAME,MODEL,SIZE,TYPE,TRAN | grep "usb\\|disk"
						echo ""
						read -p "[?] Enter target USB device ID (e.g. sdb): " USB_ID
						if [ -n "$USB_ID" ]; then
							TARGET_DEV="/dev/$USB_ID"
							echo "[!] WARNING: ALL DATA ON $TARGET_DEV WILL BE DESTROYED."
							read -p "    Type 'yes' to confirm: " CONFIRM_DD
							if [ "$CONFIRM_DD" = "yes" ]; then
								echo "[*] Flashing (sudo privileges required)..."
								sudo dd if="$ISO_PATH" of="$TARGET_DEV" bs=4M status=progress && sync
								echo "[✓] Flashing complete."
								echo "    Please boot the server with this USB stick and connect ethernet."
								read -p "    Press Enter when ready to connect..."
							else
								echo "    Aborted flashing."
							fi
						fi
					else
						echo "    1. Flash manually: sudo dd if=$ISO_PATH of=/dev/sdX bs=4M status=progress"
						echo "    2. Boot server, connect ethernet."
						read -p "    Press Enter when ready..."
					fi
					rm iso.nix
				fi

				# 2. Connection
				TARGET_IP=""
				while [ -z "$TARGET_IP" ]; do
					echo ""
					read -p "[?] Target Server IP: " INPUT_IP
					if [ -n "$INPUT_IP" ]; then
						TARGET_IP="$INPUT_IP"
					fi
				done

				# Clean up old keys
				ssh-keygen -R "$TARGET_IP" 2>/dev/null

				USERNAME=""
				while [ -z "$USERNAME" ]; do
					read -p "[?] SSH Username (default: root): " INPUT_USER
					if [ -z "$INPUT_USER" ]; then
						USERNAME="root"
					else
						USERNAME="$INPUT_USER"
					fi
				done
				echo "[*] Verifying SSH connection..."
				if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USERNAME@$TARGET_IP" "echo connected" > /dev/null 2>&1; then
					echo "[✓] Connection established."
				else
					echo "[!] Failed to connect to $USERNAME@$TARGET_IP"
					exit 1
				fi

				# 4. Disk Configuration
				echo ""
				read -p "[?] Configure Disk ID? [y/N] " SET_DISK
				if [ "$SET_DISK" = "y" ] || [ "$SET_DISK" = "Y" ]; then
					echo "[*] Available disks:"
					ssh -o StrictHostKeyChecking=no "$USERNAME@$TARGET_IP" "ls -l /dev/disk/by-id/"
					
					echo ""
					read -p "[?] Enter Disk ID (name only, e.g. nvme-Samsung...): " DISK_ID
					
					if [ -n "$DISK_ID" ]; then
						AUTO_SETUP_DIR="./hosts/hosts/$HOST_NAME/autoSetups"
						mkdir -p "$AUTO_SETUP_DIR"
						DISKO_FILE="$AUTO_SETUP_DIR/disko.nix"
						
						echo "[*] Writing configuration to $DISKO_FILE..."
						cat > "$DISKO_FILE" <<EOF
{ config, lib, ... }:
{
    config = lib.mkIf config.server.system.filesystem.disko.enable {
        server.system.filesystem.disko.diskId = "$DISK_ID";
    };
}
EOF
						echo "[✓] Created $DISKO_FILE"
						git add "$DISKO_FILE"
						echo "[✓] Added $DISKO_FILE to git staging"
					fi
				fi

				# 5. Harware Configuration
				echo ""
				read -p "[?] Generate hardware-configuration.nix? [y/N] " GEN_HW
				if [ "$GEN_HW" = "y" ] || [ "$GEN_HW" = "Y" ]; then
					echo "[*] Generating hardware-configuration.nix..."
					ssh -o StrictHostKeyChecking=no "root@$TARGET_IP" "nixos-generate-config --no-filesystems --show-hardware-config" > "./hosts/hosts/$HOST_NAME/hostConfigs/hardware-configuration.nix"
					echo "[✓] Saved to ./hosts/hosts/$HOST_NAME/hostConfigs/hardware-configuration.nix"
					git add "./hosts/hosts/$HOST_NAME/hostConfigs/hardware-configuration.nix"
					echo "[✓] Added hardware-configuration.nix to git staging"
				fi

				# 6. Deployment
				echo ""
				echo "[*] deploying .#$HOST_NAME to $TARGET_IP..."
				SSH_AUTH_SOCK="" ${nixos-anywhere.packages."x86_64-linux".nixos-anywhere}/bin/nixos-anywhere --ssh-option "IdentitiesOnly=yes" --flake .#$HOST_NAME "root@$TARGET_IP"

				# 7. Post-Installation
				echo ""
				read -p "[?] Clone configuration repo on server? [y/N] " CLONE_REPO
				if [ "$CLONE_REPO" = "y" ] || [ "$CLONE_REPO" = "Y" ]; then
					echo "[*] Configuration for post-install:"
					read -p "    SSH User (e.g. fulcrum): " SSH_USER
					read -p "    Git Repository URL: " GIT_REPO
					read -p "    Target Directory (e.g. /home/$SSH_USER/.dotfiles): " TARGET_DIR
					
					if [ -n "$GIT_REPO" ] && [ -n "$TARGET_DIR" ] && [ -n "$SSH_USER" ]; then
						# Clean up known_hosts again as the server key likely changed after reinstall
						ssh-keygen -R "$TARGET_IP" 2>/dev/null
						
						echo "[*] Waiting for server to reboot and come online..."
						while ! ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$SSH_USER@$TARGET_IP" "echo ready" > /dev/null 2>&1; do
							sleep 5
							echo -n "."
						done
						echo ""
						echo "[✓] Server is back online."
						
						echo "[*] Cloning repository..."
						ssh -t -o StrictHostKeyChecking=no "$SSH_USER@$TARGET_IP" "git clone \"$GIT_REPO\" \"$TARGET_DIR\""
						echo "[✓] Repository cloned to $TARGET_DIR"
					else
						echo "[!] Missing information. Skipping clone."
					fi
				fi

				# Step 8. Secrets Setup
				echo ""
				read -p "[?] Setup SOPS secrets on server? [y/N] " SETUP_SOPS
				if [ "$SETUP_SOPS" = "y" ] || [ "$SETUP_SOPS" = "Y" ]; then
					echo "[*] Setting up SOPS..."
					ssh -t -o StrictHostKeyChecking=no "$USERNAME@$TARGET_IP" "sudo setup-sops"
					echo "[✓] SOPS setup complete."
				fi

			'');
		};
	};
}
