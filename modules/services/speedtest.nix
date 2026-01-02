{
  config,
  lib,
  ...
}: let
  cfg = config.server.speedtest;
in {
  options.server.speedtest.enable = lib.mkEnableOption "speedtest-tracker";

  config = lib.mkIf cfg.enable {
    sops.secrets."speedtest/key" = {};
    sops.templates."speedtest-env".content = ''
      APP_KEY=${config.sops.placeholder."speedtest/key"}
    '';

    virtualisation.oci-containers.containers.speedtest = {
      image = "lscr.io/linuxserver/speedtest-tracker:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      environment = {
        PUID = "1000";
        PGID = "100";
        DB_CONNECTION = "sqlite";
        DISPLAY_TIMEZONE = "Europe/Berlin";
        PUBLIC_DASHBOARD = "true";
        SPEEDTEST_SCHEDULE = "*/10 * * * *";
      };
      environmentFiles = [config.sops.templates."speedtest-env".path];
      ports = ["8080:80"];
      volumes = ["/home/lua/podman/speedtest:/config"];
    };
  };
}
