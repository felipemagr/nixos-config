# Placeholder until install day: replace with `nixos-generate-config --root /mnt` output.
{
  fileSystems."/" = {
    device = "/dev/md0";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOTA";
    fsType = "vfat";
  };
  fileSystems."/boot-fallback" = {
    device = "/dev/disk/by-label/BOOTB";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
