{
  config,
  lib,
  ...
}: let
  cfg = config.server.miniflux;
in {
  options.server.miniflux.enable = lib.mkEnableOption "miniflux";

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "miniflux/oidc_client_secret".mode = "0444";
        "miniflux/oidc_client_id".mode = "0444";
        "miniflux/db" = {};
        "miniflux/password" = {};
        "miniflux/user" = {};
      };
      templates."miniflux-env".content = ''
        DATABASE_URL=postgres://${config.sops.placeholder."miniflux/user"}:${config.sops.placeholder."miniflux/password"}@miniflux-db/${config.sops.placeholder."miniflux/db"}?sslmode=disable
      '';
    };

    programs.rust-motd.settings.service_status.miniflux = config.virtualisation.oci-containers.containers.miniflux.serviceName;
    virtualisation.oci-containers.containers = {
      miniflux = {
        image = "ghcr.io/miniflux/miniflux:latest";
        autoStart = true;
        dependsOn = ["miniflux-db"];
        capabilities.ALL = false;
        extraOptions = [
          "--health-cmd=[\"/usr/bin/miniflux\", \"-healthcheck\", \"auto\"]"
          "--health-interval=30s"
          "--health-timeout=10s"
          "--read-only"
          "--security-opt=no-new-privileges"
        ];
        labels."io.containers.autoupdate" = "registry";
        environmentFiles = [
          config.sops.templates."miniflux-env".path
        ];
        environment = {
          OAUTH2_CLIENT_ID_FILE = "/run/secrets/oidc_client_id";
          OAUTH2_CLIENT_SECRET_FILE = "/run/secrets/oidc_client_secret";
          OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://id.lua.one";
          OAUTH2_PROVIDER = "oidc";
          OAUTH2_REDIRECT_URL = "https://rss.lua.one/oauth2/oidc/callback";
          OAUTH2_USER_CREATION = "1";
          DISABLE_LOCAL_AUTH = "true";
          RUN_MIGRATIONS = "1";
          FETCHER_ALLOW_PRIVATE_NETWORKS = "1";
        };
        volumes = [
          "${config.sops.secrets."miniflux/oidc_client_secret".path}:/run/secrets/oidc_client_secret:ro"
          "${config.sops.secrets."miniflux/oidc_client_id".path}:/run/secrets/oidc_client_id:ro"
        ];
      };
      miniflux-db = {
        image = "docker.io/postgres:18-alpine";
        user = "70";
        autoStart = true;
        capabilities = {
          ALL = false;
          CHOWN = true;
          SETGID = true;
          SETUID = true;
          DAC_OVERRIDE = true;
        };
        extraOptions = [
          "--health-cmd=[\"pg_isready\"]"
          "--health-interval=10s"
          "--health-start-period=30s"
          "--read-only"
          "--security-opt=no-new-privileges"
        ];
        labels."io.containers.autoupdate" = "registry";
        environment = {
          POSTGRES_USER_FILE = "/run/secrets/user";
          POSTGRES_PASSWORD_FILE = "/run/secrets/password";
          POSTGRES_DB_FILE = "/run/secrets/db";
        };
        volumes = [
          "/home/lua/podman/miniflux:/var/lib/postgresql"
          "${config.sops.secrets."miniflux/password".path}:/run/secrets/password:ro"
          "${config.sops.secrets."miniflux/user".path}:/run/secrets/user:ro"
          "${config.sops.secrets."miniflux/db".path}:/run/secrets/db:ro"
        ];
      };
    };
  };
}
