{
  config,
  lib,
  ...
}: let
  cfg = config.server.rustypaste;
in {
  options.server.rustypaste.enable = lib.mkEnableOption "rustypaste";

  config = lib.mkIf cfg.enable {
    sops.secrets.rustypasteToken = {};

    virtualisation.oci-containers.containers.rustypaste = {
      image = "docker.io/orhunp/rustypaste:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      user = "1000:100";
      environment = {
        AUTH_TOKENS_FILE = "/run/secrets/tokens";
      };
      volumes = [
        "/home/lua/podman/rustypaste:/app/upload"
        "/home/lua/podman/rustypaste.toml:/app/config.toml"
        "${config.sops.secrets.rustypasteToken.path}:/run/secrets/tokens"
      ];
    };
  };
}
