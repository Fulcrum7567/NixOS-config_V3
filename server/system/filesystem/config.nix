{ config, lib, ... }:
{
  config = lib.mkIf config.server.filesystem.enable {
      # We create a helper variable to hold the generated ZFS config
    generatedZfsConfig = lib.mapAttrs (shareId: shareConfig: {
      let
        datasetName = "${shareConfig.datapool}/${shareId}";
        mountPoint = "${cfg.mountPrefix}/${shareId}";
      in
      {
        fileSystems."${mountPoint}" = {
          device = datasetName;
          fsType = "zfs";
        };
      }
    }) cfg.shares;

    # Merge all generated fileSystems entries
    fileSystems = lib.mkMerge (lib.mapAttrsToList (name: value: value.fileSystems) config.generatedZfsConfig);
  };
}