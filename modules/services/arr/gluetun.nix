{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.server.arr;
in {
  options.server.arr.enable = lib.mkEnableOption "the *arr-stack & gluetun";

  config = lib.mkIf cfg.enable {
    sops.secrets."wireguard/private_key" = {};
    sops.secrets."deluge_password" = {};

    virtualisation.oci-containers.containers.gluetun = let
      script_file = "deluge_set_incoming_port.sh";
      authConfig = (pkgs.formats.toml {}).generate "gluetun_auth" {
        roles = [
          {
            name = "check_status";
            routes = ["GET /v1/publicip/ip" "GET /v1/vpn/status"];
            auth = "none";
          }
        ];
      };
    in {
      image = "ghcr.io/qdm12/gluetun:latest";
      autoStart = true;
      labels = {"io.containers.autoupdate" = "registry";};
      capabilities = {
        NET_ADMIN = true;
        NET_RAW = true;
      };
      environment = {
        VPN_SERVICE_PROVIDER = "protonvpn";
        VPN_TYPE = "wireguard";
        SERVER_COUNTRIES = "Germany";
        VPN_PORT_FORWARDING = "on";
        PORT_FORWARD_ONLY = "on";
        VPN_PORT_FORWARDING_UP_COMMAND = "/bin/sh -c '/gluetun/script/${script_file} {{PORT}}'";
      };
      volumes = [
        "${config.sops.secrets."wireguard/private_key".path}:/run/secrets/wireguard_private_key"
        "${config.sops.secrets."deluge_password".path}:/run/secrets/deluge_password"
        "${authConfig}:/gluetun/auth/config.toml"
        "${../../../files/${script_file}}:/gluetun/script/${script_file}"
      ];
      devices = ["/dev/net/tun:/dev/net/tun"];
      ports = [
        "8000:8000" # gluetun
        "8112:8112" # deluge
        "6767:6767"
        "7878:7878"
        "8989:8989"
        "9696:9696"
      ];
      extraOptions = ["--sysctl=net.ipv6.conf.all.disable_ipv6=1"];
    };
  };
}
