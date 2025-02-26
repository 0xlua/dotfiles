{config, ...}: {
  sops.secrets.linkdingOidcSecret = {};
  sops.templates."linkding-env".content = ''
    OIDC_RP_CLIENT_SECRET=${config.sops.placeholder.linkdingOidcSecret}
  '';
  virtualisation.oci-containers.containers.linkding = {
    image = "docker.io/sissbruecker/linkding:latest";
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    user = "1000:100";
    environmentFiles = [
      config.sops.templates."linkding-env".path
    ];
    environment = {
      LD_SUPERUSER_NAME = "lua";
      LD_ENABLE_OIDC = "True";
      OIDC_OP_AUTHORIZATION_ENDPOINT = "https://auth.lua.one/auth/v1/oidc/authorize";
      OIDC_OP_TOKEN_ENDPOINT = "https://auth.lua.one/auth/v1/oidc/token";
      OIDC_OP_USER_ENDPOINT = "https://auth.lua.one/auth/v1/oidc/userinfo";
      OIDC_OP_JWKS_ENDPOINT = "https://auth.lua.one/auth/v1/oidc/certs";
      OIDC_RP_CLIENT_ID = "linkding";
    };
    volumes = [
      "/home/lua/podman/linkding:/etc/linkding/data"
    ];
  };
}
