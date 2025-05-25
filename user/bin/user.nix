{ config, hostSecretsFile, ... }:
{
	sops.secrets.hostPassword = {
		sopsFile = hostSecretsFile;
		mode = "0400";
		owner = "root";
	};

	users.users.${config.user.settings.username} = {
	    isNormalUser = true;
	    description = config.user.settings.displayName;
	    extraGroups = [ "networkmanager" "wheel" ];
	    uid = 1000;
	    hashedPasswordFile = config.sops.hostPassword.path; # "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
  	};
} 
