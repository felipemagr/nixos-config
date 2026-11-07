# Selecta, a voice record picker: https://github.com/felipemagr/selecta
# Secrets (chmod 600): /var/lib/selecta/db.env (POSTGRES_PASSWORD) and selecta.env (see .env.example).
# HTTPS for the phone, once: tailscale serve --bg --https=443 http://127.0.0.1:8000
{pkgs, ...}: {
  virtualisation.oci-containers.containers = {
    selecta-db = {
      image = "pgvector/pgvector:pg17@sha256:7d0a41464797aeb9862dfdc0bbf1526b82cfd324cdd8036df19e3545f4a9ccb8";
      extraOptions = ["--network=host"];
      # 5432 is Nextcloud's.
      cmd = ["postgres" "-c" "port=5433" "-c" "listen_addresses=127.0.0.1"];
      environment = {
        POSTGRES_USER = "selecta";
        POSTGRES_DB = "selecta";
      };
      environmentFiles = ["/var/lib/selecta/db.env"];
      volumes = ["/mnt/storage/selecta/postgres:/var/lib/postgresql/data"];
    };

    selecta = {
      image = "ghcr.io/felipemagr/selecta@sha256:f7f4981e4acc129874cebf8a01a9b3597c5d9ddb789097e72c4a4b4c70a8ac60";
      extraOptions = ["--network=host"];
      dependsOn = ["selecta-db"];
      environmentFiles = ["/var/lib/selecta/selecta.env"];
      volumes = ["/mnt/storage/selecta/data:/data"];
    };
  };

  # Owned by the images' users (postgres 999, app 10001): tmpfiles resets owners on every switch.
  systemd.tmpfiles.rules = [
    "d /var/lib/selecta 0700 root root -"
    "d /mnt/storage/selecta/postgres 0700 999 999 -"
    "d /mnt/storage/selecta/data 0700 10001 10001 -"
  ];

  systemd.services.selecta-sync = {
    startAt = "04:00";
    script = "${pkgs.podman}/bin/podman exec selecta selecta sync";
  };
}
