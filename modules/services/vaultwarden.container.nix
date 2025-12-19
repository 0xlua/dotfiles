{...}: {
  virtualisation.oci-containers.containers.vaultwarden = {
    image = "docker.io/vaultwarden/server:latest";
    autoStart = true;
    # user = "1000:100"
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    environment = {
      DOMAIN = "https://vault.lua.one";
      SIGNUPS_ALLOWED = "false";
    };
    volumes = [
      "/home/lua/podman/vaultwarden:/data"
    ];
  };
}
