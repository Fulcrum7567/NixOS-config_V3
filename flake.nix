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

		# input nixpkgs
		nixpkgs-stable.url = "nixpkgs/nixos-24.11";
		nixpkgs-unstable.url = "nixpkgs/nixos-unstable";


		# input home-manager
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

	};


	outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager-stable, home-manager-unstable, sops-nix, ... }:
	let

		currentHost = (import ./hosts/currentHost.nix).currentHost;

		hostSettings = (import ./hosts/${currentHost}/hostSettingsRaw.nix);


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
	in
	{
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

				# Host
				./hosts/${currentHost}/hostConfigs/configuration.nix
				./hosts/${currentHost}/hostConfigs/hostSettings.nix

				# User
				./user/bin/user.nix
				./user/bin/userSettings.nix
				#./user/bin/var.nix

				# Packages
				./user/packages/bin/packageImporter.nix

            ];
            specialArgs = {
            	inherit currentHost;
            	hostSettingsRaw = hostSettings;
            };
          };
        };


	};
	
} 
