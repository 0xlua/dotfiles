{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.arr.flaresolverr;
in {
  options.modules.roles.server.arr.flaresolverr.enable = lib.mkEnableOption "flaresolverr";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.flaresolverr = {
      image = "ghcr.io/flaresolverr/flaresolverr:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      networks = ["container:gluetun"];
      dependsOn = ["gluetun" "flaresolverr"];
    };
  };
}
