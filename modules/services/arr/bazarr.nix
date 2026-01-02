{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr.bazarr;
in {
  options.server.arr.bazarr.enable = lib.mkEnableOption "bazarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.bazarr = {
      image = "lscr.io/linuxserver/bazarr:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      environment.PUID = "1000";
      environment.PGID = "100";
      volumes = [
        "/home/lua/media/movies:/movies:z"
        "/home/lua/media/tv:/tv:z"
        "/home/lua/podman/bazarr:/config:Z"
      ];
      networks = ["container:gluetun"];
      dependsOn = ["gluetun" "flaresolverr"];
    };
  };
}
