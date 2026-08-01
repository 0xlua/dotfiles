{
  config,
  lib,
  ...
}: let
  cfg = config.server.atuin;
in {
  options.server.atuin.enable = lib.mkEnableOption "atuin";

  config = lib.mkIf cfg.enable {
    programs.rust-motd.settings.service_status.atuin = config.virtualisation.oci-containers.containers.atuin.serviceName;
    virtualisation.oci-containers.containers.atuin = {
      image = "ghcr.io/atuinsh/atuin:18.18";
      autoStart = true;
      user = "1000";
      capabilities.ALL = false;
      extraOptions = [
        "--health-cmd=[\"curl\", \"-fsS\", \"http://localhost:8888/healthz\"]"
        "--health-interval=30s"
        "--health-timeout=5s"
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      cmd = ["start"];
      labels."io.containers.autoupdate" = "registry";
      environment = {
        ATUIN_DB_URI = "sqlite:///config/atuin.db";
        ATUIN_HOST = "0.0.0.0";
        ATUIN_OPEN_REGISTRATION = "false";
      };
      volumes = ["/home/lua/podman/atuin:/config"];
    };
  };
}
