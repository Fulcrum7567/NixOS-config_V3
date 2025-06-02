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
		nixpkgs-stable.url = "nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";


		# Input home-manager
		home-manager-stable = {
			url = "github:nix-community/home-manager/release-24.11";
			inputs.nixpkgs.follows = "nixpkgs-stable";
		};
		
		home-manager-unstable = {
				url = "github:nix-community/home-manager/master";
				inputs.nixpkgs.follows = "nixpkgs-unstable";
		};


		# Sops-nix
		sops-nix.url = "github:Mic92/sops-nix";


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
		nixcord.url = "github:kaylorben/nixcord";


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

	};


	outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager-stable, home-manager-unstable, sops-nix, nixcord, zen-browser-stable, zen-browser-unstable, mikuboot, ... }:
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

		currentHost = (import ./hosts/currentHost.nix).currentHost;

		hostSettings = (import ./hosts/${currentHost}/hostSettingsRaw.nix);


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

		pkgs-stable = nixpkgs-stable {
			system = hostSettings.system;
			config = {
			  	allowUnfree = true;
			  	allowUnfreePredicate = (_: true);
			  	allowInsecure = true;
			  	permittedInsecurePackages = [ "openssl-1.1.1w" ];
			};
		};

		pkgs-unstable = nixpkgs-unstable {
			system = hostSettings.system;
			config = {
			  	allowUnfree = true;
			  	allowUnfreePredicate = (_: true);
			  	allowInsecure = true;
			  	permittedInsecurePackages = [ "openssl-1.1.1w" ];
			};
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

		home-manager = (if (hostSettings.systemState == "stable")
						then
							home-manager-stable
						else
							home-manager-unstable
						);



		zen-browser = (if (hostSettings.defaultPackageState == "stable")
					then
						zen-browser-unstable
					else
						zen-browser-unstable
			);

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


		nixosConfigurations = {
			${currentHost} = lib.nixosSystem {
            	system = hostSettings.system;
            	modules = [
					# Home Manager as a NixOS module
					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
					}

					# Sops-nix
					sops-nix.nixosModules.sops

					# Options
					./system/options/hostOptions.nix
					./system/options/userOptions.nix
					./system/options/themeOptions.nix
					./system/options/displayManagers.nix
					./system/options/desktopOptions.nix

					# Host
					./hosts/${currentHost}/hostConfigs/configuration.nix
					./hosts/${currentHost}/hostSettings.nix

					# User
					./user/bin/user.nix
					./user/bin/userSettings.nix
					./user/bin/var.nix
					./user/bin/home.nix
					
					# Theming
					./user/themes/bin/components/importer.nix
					./user/themes/profiles/importer.nix

					# Desktop
					./user/desktops/displayManagers/importer.nix
					./user/desktops/environments/gnome/profiles/importer.nix

					# Packages
					./user/packages/bin/importer.nix
        		];
        
        		specialArgs = {
        			inherit currentHost inputs pkgs-default zen-browser;
        			hostSettingsRaw = hostSettings;
        		};
      		};
		};
	};
} 
