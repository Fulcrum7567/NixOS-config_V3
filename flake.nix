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


	outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager-stable, home-manager-unstable, sops-nix-stable, sops-nix-unstable, nixcord, zen-browser-stable, zen-browser-unstable, mikuboot, stylix-stable, stylix-unstable, nix-vscode-extensions, flatpak, nvf-stable, nvf-unstable, hyprland-stable, hyprland-unstable, chaotic, disko-stable, disko-unstable, hyprgrass-stable, hyprgrass-unstable, waybar, noctalia-stable, noctalia-unstable, ... }:
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

						# Host
						./hosts/hosts/${host}/hostConfigs/configuration.nix
						./hosts/hosts/${host}/hostSettings.nix
						./hosts/components/importer.nix
						./hosts/fixes/importer.nix
						./hosts/hosts/${host}/quickFixes.nix

						# Server
						./server/system/filesystem/imports.nix

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
						inherit currentHost inputs pkgs-default pkgs-stable pkgs-unstable zen-browser nvf hyprland hyprgrass disko sops-nix waybar noctalia;
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
	};
} 
