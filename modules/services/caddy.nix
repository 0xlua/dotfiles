{
  config,
  lib,
  ...
}: let
  cfg = config.server.caddy;
in {
  options.server.caddy.enable = lib.mkEnableOption "caddy";

  config = lib.mkIf cfg.enable {
    programs.rust-motd.settings.service_status.caddy = config.virtualisation.oci-containers.containers.caddy.serviceName;
    virtualisation.oci-containers.containers.caddy = {
      image = "docker.io/caddy:2-alpine";
      user = "1000:100";
      capabilities = {
        ALL = false;
        NET_BIND_SERVICE = true;
        NET_ADMIN = true; #optional: improves HTTP/3 performance
      };
      extraOptions = [
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      volumes = [
        "${../../files/caddy}:/etc/caddy:ro"
        "/home/lua/podman/static:/srv"
        "/home/lua/podman/caddy:/data"
      ];
      ports = ["80:80/tcp" "443:443/tcp" "443:443/udp"];
    };
  };
}
