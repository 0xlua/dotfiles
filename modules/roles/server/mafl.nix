{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.mafl;
in {
  options.modules.roles.server.mafl.enable = lib.mkEnableOption "mafl";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.mafl = {
      image = "ghcr.io/hywax/mafl:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      volumes = [
        "${../../../files/mafl.yml}:/app/data/config.yml:Z"
      ];
      ports = ["3000:3000"];
    };
  };
}
