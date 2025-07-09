{ config, lib, inputs, settings, pkgs-default, pkgs-stable, pkgs-unstable, pkgs, ... }:
let
    option = config.theming.components.${settings.optionName};

    # Import the custom font package
    aurebesh-font = pkgs.callPackage ../../bin/aurebesh/aurebesh-font.nix {};
in
{
    config = lib.mkIf (option.enable && (option.active == "default")) {

        # Add the font package to the system-wide fonts so it's available
        fonts.packages = [ aurebesh-font ];

        home-manager.users.fulcrum.programs.vscode.profiles.default.userSettings."markdown.preview.fontFamily" = lib.mkForce "Aurebesh AF";

        stylix = {
            fonts = {

                # Use the custom font for sansSerif
                sansSerif = {
                    package = aurebesh-font;
                    name = "Aurebesh AF";
                };

                # Use the custom font for serif
                serif = {
                    package = aurebesh-font;
                    name = "Aurebesh AF";
                };

                sizes = {
                    applications = 12;
                    terminal = 15;
                    desktop = 10;
                    popups = 10;
                };
            };
        };
        
    };
}
