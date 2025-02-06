{...}: {
  virtualisation.oci-containers.containers.caddy = {
    image = "docker.io/caddy:latest";
    user = "1000:100";
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/home/lua/podman/Caddyfile:/etc/caddy/Caddyfile"
      "/home/lua/podman/static:/srv"
      "/home/lua/podman/caddy:/data"
    ];
    ports = ["80:80" "443:443"];
  };
}
