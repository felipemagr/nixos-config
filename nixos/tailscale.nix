{
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # Tailnet: SSH, DNS, Nextcloud, Samba, Navidrome, Pi-hole web.
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [22 53 80 445 4533 8080];
    allowedUDPPorts = [53];
  };
}
