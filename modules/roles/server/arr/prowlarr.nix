{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr.prowlarr;
in {
  options.server.arr.prowlarr.enable = lib.mkEnableOption "prowlarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.prowlarr = {
      image = "lscr.io/linuxserver/prowlarr:latest";
      autoStart = true;
      environment.PUID = "1000";
      environment.PGID = "100";
      labels."io.containers.autoupdate" = "registry";
      volumes = ["/home/lua/podman/prowlarr:/config:Z"];
      networks = ["container:gluetun"];
      dependsOn = ["gluetun"];
    };
  };
}
