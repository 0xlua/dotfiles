{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.kitchenowl;
in {
  options.modules.roles.server.kitchenowl.enable = lib.mkEnableOption "kitchenowl";

  config = lib.mkIf cfg.enable {
    sops.secrets."kitchenowl/jwt_token" = {
      mode = "0440";
    };
    sops.secrets."kitchenowl/oidc_client_secret" = {
      mode = "0440";
    };

    virtualisation.oci-containers.containers.kitchenowl = {
      image = "docker.io/tombursch/kitchenowl:latest";
      autoStart = true;
      capabilities.ALL = false;
      extraOptions = [
        "--health-cmd=[\"uwsgi_curl\", \"localhost:5000\", \"/api/health/8M4F88S8ooi4sMbLBfkkV7ctWwgibW6V\"]"
        "--health-interval=60s"
        "--health-timeout=3s"
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      labels."io.containers.autoupdate" = "registry";
      user = "1000:100";
      environment = {
        FRONT_URL = "https://kitchen.lua.one";
        OIDC_ISSUER = "https://id.lua.one";
        OIDC_CLIENT_ID = "9372f514-08ff-4e4e-ad52-ccded189e940";
        JWT_SECRET_KEY_FILE = "/run/secrets/jwt_secret_key";
        OIDC_CLIENT_SECRET_FILE = "/run/secrets/oidc_client_secret";
        OIDC_RFC_COMPLIANT_REDIRECT = "False";
        DISABLE_USERNAME_PASSWORD_LOGIN = "true";
      };
      volumes = [
        "/home/lua/podman/kitchenowl:/data"
        "${config.sops.secrets."kitchenowl/jwt_token".path}:/run/secrets/jwt_secret_key:ro,U"
        "${config.sops.secrets."kitchenowl/oidc_client_secret".path}:/run/secrets/oidc_client_secret:ro,U"
      ];
    };
  };
}
