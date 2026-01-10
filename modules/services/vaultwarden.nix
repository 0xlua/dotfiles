{
  config,
  lib,
  ...
}: let
  cfg = config.server.vaultwarden;
in {
  options.server.vaultwarden.enable = lib.mkEnableOption "Vaultwarden";

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."vaultwarden/smtp_username" = {};
      secrets."vaultwarden/smtp_password" = {};
      templates."vaultwarden.env".content = ''
        SMTP_USERNAME=${config.sops.placeholder."vaultwarden/smtp_username"}
        SMTP_PASSWORD=${config.sops.placeholder."vaultwarden/smtp_password"}
      '';
    };
    virtualisation.oci-containers.containers.vaultwarden = {
      image = "docker.io/vaultwarden/server:latest";
      autoStart = true;
      # user = "1000:100"
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates."vaultwarden.env".path
      ];
      environment = {
        DOMAIN = "https://vault.lua.one";
        SIGNUPS_ALLOWED = "false";
        SMTP_HOST = "mail.lua.one";
        SMTP_FROM = "vaultwarden@lua.one";
        SMTP_PORT = "465";
        SMTP_SECURITY = "force_tls";
      };
      volumes = [
        "/home/lua/podman/vaultwarden:/data"
      ];
    };
  };
}
