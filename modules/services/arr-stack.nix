{
  config,
  lib,
  ...
}: let
  cfg = config.modules.server.bazarr;
in {
  options.modules.server.bazarr.enable = lib.mkEnableOption "bazarr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      bazarr = {
        image = "lscr.io/linuxserver/bazarr:latest";
        autoStart = true;
        labels = {"io.containers.autoupdate" = "registry";};
        environment.PUID = "0";
        environment.PGID = "0";
        volumes = [
          "/home/lua/media/movies:/movies"
          "/home/lua/media/tv:/tv"
          "/home/lua/podman/bazarr:/config"
        ];
        networks = ["container:podman-gluetun"];
        dependsOn = ["gluetun" "flaresolverr"]; # TODO: also smb mount @ /home/lua/media
        extraOptions = ["--security-opt label=disable"];
      };
    };
  };
}
