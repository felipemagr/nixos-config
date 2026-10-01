# Host networking: published ports (`ports = [...]`) are NATed past the NixOS firewall.
{
  virtualisation.oci-containers.containers = {
    pihole = {
      image = "pihole/pihole:2026.09.0";
      extraOptions = ["--network=host"];
      volumes = ["/mnt/storage/pihole:/etc/pihole"];
      environment = {
        TZ = "Europe/Madrid";
        FTLCONF_webserver_port = "8080";
        # Answer tailnet clients too, not just the local subnet. The firewall decides who gets in.
        FTLCONF_dns_listeningMode = "all";
      };
    };

    navidrome = {
      image = "deluan/navidrome:0.64.2";
      extraOptions = ["--network=host"];
      user = "1000:100";
      volumes = [
        "/mnt/storage/navidrome:/data"
        "/mnt/storage/music:/music:ro"
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/storage/pihole 0755 root root -"
    "d /mnt/storage/navidrome 0755 admin users -"
    "d /mnt/storage/music 0755 admin users -"
  ];

  # DNS is the only service exposed to the LAN: private IPv4 sources only, never IPv6.
  networking.firewall.extraCommands = ''
    for net in 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16; do
      iptables -I nixos-fw -s $net -p udp --dport 53 -j nixos-fw-accept
      iptables -I nixos-fw -s $net -p tcp --dport 53 -j nixos-fw-accept
    done
  '';
}
