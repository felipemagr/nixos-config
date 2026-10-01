# Set the SMB password once: `sudo smbpasswd -a admin`.
{
  services.samba = {
    enable = true;
    settings.music = {
      path = "/mnt/storage/music";
      "read only" = "no";
      "valid users" = "admin";
      # Tailnet and localhost only, even if the firewall changes.
      "hosts allow" = "100.64.0.0/10 127.0.0.1";
    };
  };
}
