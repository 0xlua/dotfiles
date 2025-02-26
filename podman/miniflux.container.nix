{config, ...}: {
  sops.secrets."miniflux/oidcSecret" = {
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
        OAUTH2_CLIENT_ID = "miniflux";
        OAUTH2_CLIENT_SECRET_FILE = "/run/secrets/oidc";
        OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.lua.one/auth/v1";
        OAUTH2_PROVIDER = "oidc";
        OAUTH2_REDIRECT_URL = "https://rss.lua.one/oauth2/oidc/callback";
        OAUTH2_USER_CREATION = "1";
        DISABLE_LOCAL_AUTH = "true";
        RUN_MIGRATIONS = "1";
      };
      volumes = [
        "${config.sops.secrets."miniflux/oidcSecret".path}:/run/secrets/oidc"
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
