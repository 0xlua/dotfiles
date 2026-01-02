{
  config,
  lib,
  ...
}: let
  cfg = config.server.arr;
in {
  options.server.arr.enable = lib.mkEnableOption "the *arr-stack & gluetun";

  config = lib.mkIf cfg.enable {
    sops.secrets."openvpn/user" = {};
    sops.secrets."openvpn/password" = {};
    sops.templates."openvpn-env".content = ''
      OPENVPN_USER=${config.sops.placeholder."openvpn/user"}
      OPENVPN_PASSWORD=${config.sops.placeholder."openvpn/password"}
    '';

    virtualisation.oci-containers.containers.gluetun = {
      image = "ghcr.io/qdm12/gluetun:latest";
      autoStart = true;
      labels = {"io.containers.autoupdate" = "registry";};
      capabilities = {
        NET_ADMIN = true;
        NET_RAW = true;
      };
      environment = {
        VPN_SERVICE_PROVIDER = "protonvpn";
        SERVER_COUNTRIES = "Germany";
        VPN_PORT_FORWARDING = "on";
        PORT_FORWARD_ONLY = "on";
      };
      environmentFiles = [config.sops.templates."openvpn-env".path];
      devices = ["/dev/net/tun:/dev/net/tun"];
      ports = [
        "8000:8000" # gluetun
        "8112:8112"
        "6767:6767"
        "7878:7878"
        "8989:8989"
        "9696:9696"
      ];
      extraOptions = ["--sysctl=net.ipv6.conf.all.disable_ipv6=1"];
    };
  };
}
