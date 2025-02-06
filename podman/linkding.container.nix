{...}: {
  virtualisation.oci-containers.containers.linkding = {
    image = "docker.io/sissbruecker/linkding:latest";
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    user = "1000:100";
    environment = {
      LD_SUPERUSER_NAME = "lua";
      LD_ENABLE_OIDC = "True";
      OIDC_OP_AUTHORIZATION_ENDPOINT = "http://mail.lua.one/authorize/code";
      OIDC_OP_TOKEN_ENDPOINT = "http://mail.lua.one/auth/token";
      OIDC_OP_USER_ENDPOINT = "http://mail.lua.one/auth/userinfo";
      OIDC_OP_JWKS_ENDPOINT = "http://mail.lua.one/auth/jwks.json";
      OIDC_RP_CLIENT_ID = "linkding";
    };
    volumes = [
      "/home/lua/podman/linkding:/etc/linkding/data"
    ];
  };
}
