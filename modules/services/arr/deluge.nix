{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr.deluge;
in {
  options.server.arr.deluge.enable = lib.mkEnableOption "bazarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.deluge = {
      image = "lscr.io/linuxserver/deluge:latest";
      autoStart = true;
      labels = {"io.containers.autoupdate" = "registry";};
      environment.PUID = "1000";
      environment.PGID = "100";
      volumes = [
        "/home/lua/podman/deluge:/config:Z"
        "/home/lua/podman/downloads:/downloads:z"
      ];
      networks = ["container:gluetun"];
      dependsOn = ["gluetun"];
    };
  };
}
