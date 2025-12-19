{config, ...}: {
  sops.secrets."pocketIdKey" = {
    mode = "0440";
    owner = config.users.users.lua.name;
    group = config.users.users.lua.group;
  };
  virtualisation.oci-containers.containers.pocket-id = {
    image = "ghcr.io/pocket-id/pocket-id:v1";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    environment = {
      APP_URL = "https://id.lua.one";
      ANALYTICS_DISABLED = "true";
      ENCRYPTION_KEY_FILE = "/run/secrets/encryption_key";
      TRUST_PROXY = "true";
      # MAXMIND_LICENSE_KEY_FILE = "";
      PUID = "1000";
      PGID = "1000";
    };
    volumes = [
      "/home/lua/podman/pocket-id:/app/data"
      "${config.sops.secrets."pocketIdKey".path}:/run/secrets/encryption_key"
    ];
  };
}
