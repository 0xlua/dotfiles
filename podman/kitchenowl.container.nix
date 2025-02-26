{config, ...}: {
  sops.secrets.kitchenowlJwt = {};
  sops.secrets.kitchenowlOidcSecret = {};
  sops.templates."kitchenowl-env".content = ''
    JWT_SECRET_KEY=${config.sops.placeholder.kitchenowlJwt}
    OIDC_CLIENT_SECRET=${config.sops.placeholder.kitchenowlOidcSecret}
  '';

  virtualisation.oci-containers.containers.kitchenowl = {
    image = "docker.io/tombursch/kitchenowl:latest";
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    user = "1000:100";
    environmentFiles = [
      config.sops.templates."kitchenowl-env".path
    ];
    environment = {
      FRONT_URL = "https://kitchen.lua.one";
      OIDC_ISSUER = "https://auth.lua.one/auth/v1";
      OIDC_CLIENT_ID = "kitchenowl";
    };
    volumes = [
      "/home/lua/podman/kitchenowl:/data"
    ];
  };
}
