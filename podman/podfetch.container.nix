{...}: {
  virtualisation.oci-containers.containers.podfetch = {
    image = "docker.io/samuel19982/podfetch:latest";
    environment = {
      POLLING_INTERVAL = "60";
      SERVER_URL = "https://podcasts.lua.one";
      DATABASE_URL = "sqlite:///app/db/podcast.db";
      OIDC_AUTH = "true";
      OIDC_AUTHORITY = "https://mail.lua.one";
      OIDC_CLIENT_ID = "podfetch";
      OIDC_REDIRECT_URI = "https://podcasts.lua.one/ui/login";
      OIDC_SCOPE = "openid";
      OIDC_JWKS = "http://mail.lua.one/auth/jwks.json";
      GPODDER_INTEGRATION_ENABLED = "true";
    };
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/home/lua/podman/podfetch/podcasts:/app/podcasts"
      "/home/lua/podman/podfetch/db:/app/db"
    ];
  };
}
