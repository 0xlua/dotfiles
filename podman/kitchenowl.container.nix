{config, ...}: {
  sops.secrets.kitchenowlJwt = {
    mode = "0440";
  };
  sops.secrets.kitchenowlOidcSecret = {
    mode = "0440";
  };

  virtualisation.oci-containers.containers.kitchenowl = {
    image = "docker.io/tombursch/kitchenowl:latest";
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    user = "1000:100";
    environment = {
      FRONT_URL = "https://kitchen.lua.one";
      OIDC_ISSUER = "https://auth.lua.one/auth/v1";
      OIDC_CLIENT_ID = "kitchenowl";
      JWT_SECRET_KEY_FILE = "/run/secrets/jwt_secret_key";
      OIDC_CLIENT_SECRET_FILE = "/run/secrets/oidc_client_secret";
    };
    volumes = [
      "/home/lua/podman/kitchenowl:/data"
      "${config.sops.secrets.kitchenowlJwt.path}:/run/secrets/jwt_secret_key:ro,U"
      "${config.sops.secrets.kitchenowlOidcSecret.path}:/run/secrets/oidc_client_secret:ro,U"
    ];
  };
}
