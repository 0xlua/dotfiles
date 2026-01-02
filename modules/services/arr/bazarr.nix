{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr.bazarr;
in {
  options.server.arr.bazarr.enable = lib.mkEnableOption "bazarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        autoStart = true;
        labels = {"io.containers.autoupdate" = "registry";};
        environment.PUID = "1000";
        environment.PGID = "100";
        volumes = [
          "/home/lua/media/movies:/movies"
          "/home/lua/media/tv:/tv"
          "/home/lua/podman/bazarr:/config"
        ];
        networks = ["container:gluetun"];
        dependsOn = ["gluetun" "flaresolverr"]; # TODO: also smb mount @ /home/lua/media
        extraOptions = ["--security-opt label=disable"];
      };
    };
  };
}
