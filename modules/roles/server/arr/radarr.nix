{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr.radarr;
in {
  options.server.arr.radarr.enable = lib.mkEnableOption "radarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.radarr = {
      image = "lscr.io/linuxserver/radarr:latest";
      autoStart = true;
      environment.PUID = "1000";
      environment.PGID = "100";
      labels."io.containers.autoupdate" = "registry";
      volumes = [
        "/home/lua/podman/radarr:/config:Z"
        "/home/lua/podman/downloads:/downloads:z"
        "/home/lua/media/movies:/movies:z"
      ];
      networks = ["container:gluetun"];
      dependsOn = ["gluetun" "deluge" "prowlarr"];
    };
  };
}
