{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr.flaresolverr;
in {
  options.server.arr.flaresolverr.enable = lib.mkEnableOption "flaresolverr";

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
