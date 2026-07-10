{
  config,
  lib,
  ...
}: let
  cfg = config.server.stalwart;
in {
  options.server.stalwart.enable = lib.mkEnableOption "stalwart";

  config = lib.mkIf cfg.enable {
    programs.rust-motd.settings.service_status.stalwart = config.virtualisation.oci-containers.containers.stalwart.serviceName;
    virtualisation.oci-containers.containers.stalwart = {
      image = "docker.io/stalwartlabs/stalwart:v0.16";
      labels."io.containers.autoupdate" = "registry";
      ports = ["25:25" "465:465" "993:993"];
      volumes = [
        "/home/lua/podman/stalwart-etc:/etc/stalwart:Z"
        "/home/lua/podman/stalwart-data:/var/lib/stalwart:Z"
      ];
    };
  };
}
