{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disks.nix
    ./tailscale.nix
    ./dev.nix
    ./samba.nix
    ./containers.nix
    ./nextcloud.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "";
    };
    channel.enable = false;
  };

  networking.hostName = "gaddafi";

  users.users.admin = {
    isNormalUser = true;
    uid = 1000; # containers run as this uid
    initialPassword = "changeme";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBxZs/Hkl1DB6AhoqfTYnbWyINe6MCRIV3LheIjD3t+I"
    ];
  };

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

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    tmux
    tree
    curl
    wget
    unzip
    rsync
    ncdu
    smartmontools
    iotop
    dnsutils
    jq
    ripgrep
    bat
  ];
  environment.variables.EDITOR = "vim";

  networking.firewall.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  system.stateVersion = "25.11";
}
