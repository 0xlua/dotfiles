{config, ...}: {
  sops.secrets.genesisJwtSecret = {};
  sops.templates."genesis-env".content = ''
    GENESIS_JWT_SECRET=${config.sops.placeholder.genesisJwtSecret}
  '';

  virtualisation.oci-containers.containers = {
    ocular-backend = {
      image = "ghcr.io/simonwep/genesis:v1.4.0";
      autoStart = true;
      cmd = ["start"];
      volumes = [
        "/home/lua/podman/ocular:/app/.data"
      ];
      environmentFiles = [
        config.sops.templates."genesis-env".path
      ];
      environment = {
        GENESIS_DB_PATH = ".data";
        GENESIS_JWT_TOKEN_EXPIRATION = "120960";
        GENESIS_JWT_COOKIE_ALLOW_HTTP = "true";
        GENESIS_GIN_MODE = "release";
        GENESIS_LOG_MODE = "production";
        GENESIS_PORT = "80";
        GENESIS_BASE_URL = "/";
        GENESIS_USERNAME_PATTERN = "^[\w]{0,32}$";
        GENESIS_KEY_PATTERN = "^[\w]{0,32}$";
        GENESIS_DATA_MAX_SIZE = "512";
        GENESIS_KEYS_PER_USER = "2";
      };
    };
    ocular-frontend = {
      image = "ghcr.io/simonwep/ocular:v1.7.0";
      autoStart = true;
      dependsOn = ["ocular-backend"];
    };
  };
}
