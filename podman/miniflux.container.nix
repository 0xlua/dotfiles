{config, ...}: {
  sops.secrets."miniflux/oidc_client_secret" = {
    mode = "0444";
  };
  sops.secrets."miniflux/oidc_client_id" = {
    mode = "0444";
  };
  sops.secrets."miniflux/db" = {};
  sops.secrets."miniflux/password" = {};
  sops.secrets."miniflux/user" = {};
  sops.templates."miniflux-env".content = ''
    DATABASE_URL=postgres://${config.sops.placeholder."miniflux/user"}:${config.sops.placeholder."miniflux/password"}@miniflux-db/${config.sops.placeholder."miniflux/db"}?sslmode=disable
  '';

  virtualisation.oci-containers.containers = {
    miniflux = {
      image = "ghcr.io/miniflux/miniflux:latest";
      autoStart = true;
      dependsOn = ["miniflux-db"];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
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
      };
      volumes = [
        "${config.sops.secrets."miniflux/oidc_client_secret".path}:/run/secrets/oidc_client_secret"
        "${config.sops.secrets."miniflux/oidc_client_id".path}:/run/secrets/oidc_client_id"
      ];
    };
    miniflux-db = {
      image = "docker.io/postgres:17-alpine";
      environment = {
        POSTGRES_USER_FILE = "/run/secrets/user";
        POSTGRES_PASSWORD_FILE = "/run/secrets/password";
        POSTGRES_DB_FILE = "/run/secrets/db";
      };
      volumes = [
        "/home/lua/podman/miniflux:/var/lib/postgresql/data"
        "${config.sops.secrets."miniflux/password".path}:/run/secrets/password"
        "${config.sops.secrets."miniflux/user".path}:/run/secrets/user"
        "${config.sops.secrets."miniflux/db".path}:/run/secrets/db"
      ];
    };
  };
}
