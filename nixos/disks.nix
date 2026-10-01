# Two identical disks: RAID-1 for /, one ESP per disk. Layout: INSTALL.md steps 4-6.
{pkgs, ...}: {
  boot.swraid = {
    enable = true;
    # mdmonitor won't start without an alert target; log to the journal for now.
    mdadmConf = "PROGRAM ${pkgs.util-linux}/bin/logger";
  };

  # GRUB on both disks so either can boot alone, in UEFI or legacy BIOS mode.
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      {
        devices = ["/dev/sda"];
        path = "/boot";
      }
      {
        devices = ["/dev/sdb"];
        path = "/boot-fallback";
      }
    ];
  };

  # A dead disk means a missing ESP; boot anyway.
  fileSystems."/boot".options = ["nofail"];
  fileSystems."/boot-fallback".options = ["nofail"];

  systemd.tmpfiles.rules = ["d /mnt/storage 0755 admin users -"];

  zramSwap.enable = true;
}
