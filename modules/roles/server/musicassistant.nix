{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.musicassistant;
in {
  options.modules.roles.server.musicassistant.enable = lib.mkEnableOption "musicassistant";

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [8095];

    virtualisation.oci-containers.containers.musicassistant = {
      image = "ghcr.io/music-assistant/server:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      capabilities = {
        ALL = false;
        DAC_OVERRIDE = true;
      };
      networks = ["host"];
      volumes = [
        "/home/lua/podman/musicassistant:/data:Z"
        "/home/lua/Music:/media:ro"
      ];
    };
  };
}
