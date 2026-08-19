{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.soju;
in {
  options.modules.roles.server.soju.enable = lib.mkEnableOption "soju IRC Bouncer";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.soju = {
      image = "codeberg.org/emersion/soju:latest";
      user = "1000:100";
      capabilities.ALL = false;
      extraOptions = [
        "--health-cmd=[\"/sojuctl\", \"help\"]"
        "--health-interval=30s"
        "--health-timeout=10s"
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      volumes = [
        "/home/lua/podman/soju/db:/db:Z"
        "/home/lua/podman/soju/uploads:/uploads:Z"
        "${../../../files/soju.config}:/soju-config"
      ];
    };
  };
}
