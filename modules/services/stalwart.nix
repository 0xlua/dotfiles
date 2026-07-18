{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.server.stalwart;
in {
  options.server.stalwart.enable = lib.mkEnableOption "stalwart";

  config = lib.mkIf cfg.enable {
    programs.rust-motd.settings.service_status.stalwart = config.virtualisation.oci-containers.containers.stalwart.serviceName;
    virtualisation.oci-containers.containers.stalwart = let
      stalwart_config = (pkgs.formats.json {}).generate "stalwart_config" {
        "@type" = "RocksDb";
        "path" = "/var/lib/stalwart";
      };
    in {
      image = "docker.io/stalwartlabs/stalwart:v0.16";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      capabilities = {
        ALL = false;
        NET_BIND_SERVICE = true;
      };
      extraOptions = [
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      ports = ["25:25" "465:465" "993:993"];
      volumes = [
        "${stalwart_config}:/etc/stalwart/config.json:ro"
        "/home/lua/podman/stalwart-data:/var/lib/stalwart:Z"
        "/home/lua/podman/caddy/caddy/certificates/acme-v02.api.letsencrypt.org-directory/wildcard_.lua.one:/opt/certificates:ro,idmap=uids=1000-2000-1;gids=100-2000-1"
      ];
    };
  };
}
