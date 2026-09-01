{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.koito;
in {
  options.modules.roles.server.koito.enable = lib.mkEnableOption "Koito";

  config = lib.mkIf cfg.enable {
    programs.rust-motd.settings.service_status.koito = config.virtualisation.oci-containers.containers.koito.serviceName;
    virtualisation.oci-containers.containers.koito = {
      image = "docker.io/gabehf/koito:latest";
      autoStart = true;
      user = "1000:100";
      capabilities.ALL = false;
      extraOptions = [
        #   "--health-cmd=[\"curl\", \"-fsS\", \"http://localhost:4110\"]"
        #   "--health-interval=30s"
        #   "--health-timeout=5s"
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      ports = ["4110:4110/tcp"];
      labels."io.containers.autoupdate" = "registry";
      volumes = ["/home/lua/podman/koito:/etc/koito"];
    };
  };
}
