{
  config,
  lib,
  ...
}: let
  cfg = config.server.pocket-id;
in {
  options.server.pocket-id.enable = lib.mkEnableOption "pocket-id";

  config = lib.mkIf cfg.enable {
    sops.secrets."pocket_id/key" = {
      mode = "0440";
      owner = config.users.users.lua.name;
      group = config.users.users.lua.group;
    };
    sops.secrets."pocket_id/smtp_password" = {
      mode = "0440";
      owner = config.users.users.lua.name;
      group = config.users.users.lua.group;
    };
    programs.rust-motd.settings.service_status.pocket-id = config.virtualisation.oci-containers.containers.pocket-id.serviceName;
    virtualisation.oci-containers.containers.pocket-id = let
      email = "id@lua.one";
    in {
      image = "ghcr.io/pocket-id/pocket-id:v2-distroless";
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      user = "1000:1000";
      environment = {
        UI_CONFIG_DISABLED = "true";
        APP_URL = "https://id.lua.one";
        ANALYTICS_DISABLED = "true";
        ENCRYPTION_KEY_FILE = "/run/secrets/encryption_key";
        TRUST_PROXY = "true";
        SMTP_HOST = "mail.lua.one";
        SMTP_PORT = "465";
        SMTP_FROM = email;
        SMTP_USER = email;
        SMTP_PASSWORD_FILE = "/run/secrets/smtp_password";
        SMTP_TLS = "tls";
        EMAILS_VERIFIED = "true";
        # EMAIL_VERIFICATION_ENABLED = "true";
        EMAIL_LOGIN_NOTIFICATION_ENABLED = "true";
        EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = "true";
      };
      extraOptions = [
        "--health-cmd='[/app/pocket-id, healthcheck]'"
        "--health-interval=1m30s"
        "--health-timeout=5s"
        "--health-retries=2"
        "--health-start-period=10s"
        "--read-only"
      ];
      volumes = [
        "/home/lua/podman/pocket-id:/app/data"
        "${config.sops.secrets."pocket_id/key".path}:/run/secrets/encryption_key"
        "${config.sops.secrets."pocket_id/smtp_password".path}:/run/secrets/smtp_password"
      ];
    };
  };
}
