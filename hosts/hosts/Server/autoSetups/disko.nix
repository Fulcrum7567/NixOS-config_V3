{ config, lib, ... }:
{
    config = lib.mkIf config.server.system.filesystem.disko.enable {
        server.system.filesystem.disko.diskId = "ata-LITEON_CV1-CC256_KN2560L0135480091FHC";
    };
}
