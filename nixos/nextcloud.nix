# Admin password: `echo -n '<pass>' | sudo tee /var/lib/nextcloud-admin-pass` before first start.
{pkgs, ...}: {
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud32;
    hostName = "gaddafi";
    datadir = "/mnt/storage/nextcloud";
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "4G";
    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = "/var/lib/nextcloud-admin-pass";
    };
    # Defaults allow 120 PHP workers; far too many for 4 GB.
    poolSettings = {
      pm = "dynamic";
      "pm.max_children" = "8";
      "pm.start_servers" = "2";
      "pm.min_spare_servers" = "1";
      "pm.max_spare_servers" = "3";
      "pm.max_requests" = "500";
    };
  };
}
