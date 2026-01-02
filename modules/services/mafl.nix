{
  config,
  lib,
  ...
}: let
  cfg = config.server.mafl;
in {
  options.server.mafl.enable = lib.mkEnableOption "mafl";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.mafl = {
      image = "ghcr.io/hywax/mafl:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      volumes = [
        "/home/lua/mafl.yml:/app/data/config.yml:Z"
      ];
      ports = ["3000:3000"];
    };
  };
}
