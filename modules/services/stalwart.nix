{
  config,
  lib,
  ...
}: let
  cfg = config.server.stalwart;
in {
  options.server.stalwart.enable = lib.mkEnableOption "stalwart";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.stalwart = {
      image = "docker.io/stalwartlabs/stalwart:latest";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = ["25:25" "465:465" "993:993"];
      volumes = [
        "/home/lua/podman/stalwart:/opt/stalwart"
      ];
    };
  };
}
