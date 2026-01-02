{
  config,
  lib,
  ...
}: let
  cfg = config.server.musicassistant;
in {
  options.server.musicassistant.enable = lib.mkEnableOption "musicassistant";

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [8095];

    virtualisation.oci-containers.containers.musicassistant = {
      image = "ghcr.io/music-assistant/server:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      capabilities = {
        SYS_ADMIN = true;
        DAC_READ_SEARCH = true;
      };
      networks = ["host"];
      extraOptions = ["--security-opt=apparmor=unconfined"];
      volumes = [
        "/home/lua/podman/musicassistant:/config:Z"
      ];
    };
  };
}
