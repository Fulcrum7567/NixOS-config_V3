{ pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
  users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEo0U1cWCMJLVEPg/vX4v56aAx/M1SaklhnpUydxSsd server-setup" ];
}
