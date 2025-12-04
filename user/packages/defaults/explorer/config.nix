{ config, lib, ... }:
{
  home-manager.users.${config.user.settings.username} = {

    home.file = {

      "Templates/newTextDocument.txt".text = "";
      "Templates/newNixFile.nix".source = ./bin/templates/newNixFile.nix;
      "Templates/importer.nix".source = ./bin/templates/importer.nix;
      "Templates/imports.nix".source = ./bin/templates/imports.nix;
    };

  };
}