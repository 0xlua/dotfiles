{
  config,
  lib,
  ...
}: let
  cfg = config.server.linkding;
in {
  options.server.linkding.enable = lib.mkEnableOption "linkding";

  config = lib.mkIf cfg.enable {
    sops.secrets."linkding/oidc_client_id" = {};
    sops.secrets."linkding/oidc_client_secret" = {};
    sops.templates."linkding-env".content = ''
      OIDC_RP_CLIENT_ID=${config.sops.placeholder."linkding/oidc_client_id"}
      OIDC_RP_CLIENT_SECRET=${config.sops.placeholder."linkding/oidc_client_secret"}
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
        LD_DISABLE_LOGIN_FORM = "True";
        OIDC_USERNAME_CLAIM = "preferred_username";
        OIDC_OP_AUTHORIZATION_ENDPOINT = "https://id.lua.one/authorize";
        OIDC_OP_TOKEN_ENDPOINT = "https://id.lua.one/api/oidc/token";
        OIDC_OP_USER_ENDPOINT = "https://id.lua.one/api/oidc/userinfo";
        OIDC_OP_JWKS_ENDPOINT = "https://id.lua.one/.well-known/jwks.json";
      };
      volumes = [
        "/home/lua/podman/linkding:/etc/linkding/data"
      ];
    };
  };
}
