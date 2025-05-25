{ config, ... }:
{
	sops.age.keyFile = "/home/${config.user.settings.username}/.config/sops/age/keys.txt";
	sops.validateSopsFiles = false;
} 
