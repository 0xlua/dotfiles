{
  config,
  lib,
  ...
}: let
  cfg = config.server.jellyfin;
in {
  options.server.jellyfin.publiclyAccessible = lib.mkEnableOption "a public tunnel for jellyfin";

  config = lib.mkIf cfg.publiclyAccessible {
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
      networks = ["container:jellyfin"];
      labels = {"io.containers.autoupdate" = "registry";};
      environmentFiles = [config.sops.templates."bore-env".path];
    };
  };
}
