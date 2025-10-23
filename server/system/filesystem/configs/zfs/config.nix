{ config, lib, ... }:
let
    zfsCompatibleKernelPackages = lib.filterAttrs (
    name: kernelPackages:
    (builtins.match "linux_[0-9]+_[0-9]+" name) != null
    && (builtins.tryEval kernelPackages).success
    && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
  ) pkgs.linuxKernel.packages;
  latestKernelPackage = lib.last (
    lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version)) (
      builtins.attrValues zfsCompatibleKernelPackages
    )
  );
in
{
  config = lib.mkIf config.server.filesystem.activeConfig == "zfs" {
    boot.kernelPackages = lib.mkForce latestKernelPackage;

    systemd.services.zfs-mount.enable = false; # Disable auto mount by systemd

    networking.hostId = "8623hf29"; # Random ID required for ZFS

    
  };
}