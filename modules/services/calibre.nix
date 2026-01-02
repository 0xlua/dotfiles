{
  config,
  lib,
  ...
}: let
  cfg = config.server.calibre;
in {
  options.server.calibre.enable = lib.mkEnableOption "calibre-web-automated";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.calibre = {
      image = "docker.io/crocodilestick/calibre-web-automated:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      environment = {
        PUID = "1000";
        PGID = "100";
        TZ = "Europe/Berlin";
      };
      ports = ["8083:8083"];
      volumes = [
        "/home/lua/podman/calibre:/config:Z"
        "/home/lua/media/books/ingest:/cwa-book-ingest:z"
        "/home/lua/media/books/lib:/calibre-library:z"
      ];
    };
  };
}
