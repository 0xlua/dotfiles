{
  config,
  lib,
  ...
}: let
  cfg = config.server.bore-client;
in {
  options.server.bore-client.enable = lib.mkEnableOption "bore client";

  config = lib.mkIf cfg.enable {
    sops.secrets.boreSecret = {};
    sops.templates."bore-env".content = ''
      BORE_SECRET=${config.sops.placeholder.boreSecret}
    '';

    virtualisation.oci-containers.containers.bore-client = {
      # StartLimitIntercalSec=0
      # RestartSec=20s
      image = "docker.io/ekzhang/bore:latest";
      cmd = ["local" "--port" "8096" "--to" "lua.one" "8096"];
      autoStart = true;
      dependsOn = ["jellyfin"];
      networks = ["container:podman-jellyfin"];
      labels = {"io.containers.autoupdate" = "registry";};
      environmentFiles = [config.sops.templates."bore-env".path];
    };
  };
}
