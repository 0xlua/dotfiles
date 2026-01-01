{
  config,
  lib,
  ...
}: let
  cfg = config.server.jellyfin;
in {
  options.server.jellyfin.enable = lib.mkEnableOption "jellyfin";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.jellyfin = {
      # StartLimitIntercalSec=0
      # BindsTo=home-lua-media.mount
      # After=home-lua-media.mount
      image = "lscr.io/linuxserver/jellyfin:latest";
      autoStart = true;
      labels = {"io.containers.autoupdate" = "registry";};
      extraOptions = ["--security-opt" "label=disable"];
      environment = {
        PUID = "1000";
        PGID = "100";
        DOCKER_MODS = "ghcr.io/jumoog/intro-skipper";
      };
      ports = ["8096:8096/tcp"];
      devices = ["/dev/dri/:/dev/dri/"];
      volumes = [
        "/home/lua/podman/jellyfin:/config"
        "/home/lua/media/movies:/data/movies"
        "/home/lua/media/tv:/data/tv"
      ];
    };
  };
}
