{ config, currentHost, ... }:
{
	sops.secrets.hostPassword = {
		sopsFile = "${config.host.settings.dotfilesDir}/hosts/hosts/${currentHost}/hostSecrets.json";
		mode = "0400";
		owner = "root";
	};

	users.users.${config.user.settings.username} = {
	    isNormalUser = true;
	    description = config.user.settings.displayName;
	    extraGroups = [ "networkmanager" "wheel" ];
	    uid = 1000;
	    hashedPasswordFile = config.sops.secrets.hostPassword.path; # "$6$swTYGVRP4erDVWWO$argE8karkQ6JyNFAEgFMiJpEYCYrIIZChmqrvXUb0VDx7lS./U661Agnv1mwJVrlx1x.ShGaznfrbgdsrdqBW0";
  	};
} 
