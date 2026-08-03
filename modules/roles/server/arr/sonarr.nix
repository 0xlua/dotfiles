{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.arr.sonarr;
in {
  options.modules.roles.server.arr.sonarr.enable = lib.mkEnableOption "sonarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.sonarr = {
      image = "lscr.io/linuxserver/sonarr:latest";
      autoStart = true;
      environment.PUID = "1000";
      environment.PGID = "100";
      labels."io.containers.autoupdate" = "registry";
      volumes = [
        "/home/lua/podman/sonarr:/config:Z"
        "/home/lua/podman/downloads:/downloads:z"
        "/home/lua/media/tv:/tv:z"
      ];
      networks = ["container:gluetun"];
      dependsOn = ["gluetun" "deluge" "prowlarr"];
    };
  };
}
