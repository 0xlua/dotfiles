{
  config,
  lib,
  ...
}: let
  cfg = config.server.homeassistant;
in {
  options.server.homeassistant.enable = lib.mkEnableOption "homeassistant";

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [8123];

    virtualisation.oci-containers.containers.homeassistant = {
      image = "ghcr.io/home-assistant/home-assistant:stable";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      environment.TZ = "Europe/Berlin";
      networks = ["host"];
      privileged = true;
      volumes = [
        "/home/lua/podman/homeassistant:/config:Z"
      ];
    };
  };
}
