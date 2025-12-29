{config, ...}: {
  sops.secrets."kitchenowl/jwt_token" = {
    mode = "0440";
  };
  sops.secrets."kitchenowl/oidc_client_secret" = {
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
      OIDC_ISSUER = "https://id.lua.one";
      OIDC_CLIENT_ID = "9372f514-08ff-4e4e-ad52-ccded189e940";
      JWT_SECRET_KEY_FILE = "/run/secrets/jwt_secret_key";
      OIDC_CLIENT_SECRET_FILE = "/run/secrets/oidc_client_secret";
    };
    volumes = [
      "/home/lua/podman/kitchenowl:/data"
      "${config.sops.secrets."kitchenowl/jwt_token".path}:/run/secrets/jwt_secret_key:ro,U"
      "${config.sops.secrets."kitchenowl/oidc_client_secret".path}:/run/secrets/oidc_client_secret:ro,U"
    ];
  };
}
