{ lib }: {

    wallpaperGroup = lib.types.submodule {
        options = {
            name = lib.mkOption {
                type = lib.types.str;
                description = "Name of the wallpaper group.";
                example = "My first wallpaper collection";
            };

            wallpapers = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                description = "A list of wallpapers.";
                example = [ "wallpaper1" "wallpaper2" ];
            };
        };
    };

}