{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # WIP: split-out modules we'll add later
    #   ./mdadm.nix       -> RAID array on /mnt/storage
    #   ./samba.nix       -> SMB shares
    #   ./containers.nix  -> Pi-hole + Navidrome (oci-containers)
  ];

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
    };
    channel.enable = false;
  };

  networking.hostName = "gadafi";

  users.users.admin = {
    isNormalUser = true;
    description = "admin";
    initialPassword = "changeme";
    extraGroups = [
      "wheel" # sudo
      # WIP: add as services come online
      #   "docker"          -> for oci-containers
      #   "networkmanager"  -> only if we switch from plain DHCP to NM
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxZs/Hkl1DB6AhoqfTYnbWyINe6MCRIV3LheIjD3t+I"
    ];
  };

  # Time & locale
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
  };
  console.keyMap = "es";

  # Base CLI packages
  environment.systemPackages = with pkgs; [
    # Basics
    git
    vim
    htop
    tmux
    tree
    curl
    wget
    unzip
    rsync
    # System/Disk
    ncdu
    smartmontools
    iotop
    # Network/DNS
    dnsutils
    # Text/JSON
    jq
    ripgrep
    bat
  ];
  environment.variables.EDITOR = "vim";

  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22]; # SSH
    allowedUDPPorts = [];
    # WIP: ports to open as services come online
    #   53          UDP+TCP -> Pi-hole DNS
    #   80, 443     TCP     -> reverse proxy / Navidrome
    #   137,138     UDP     -> Samba (NetBIOS)
    #   139,445     TCP     -> Samba (SMB)
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.11";
}
