{
  config,
  lib,
  ...
}:
lib.mkIf config.modules.roles.laptop.enable {
  sops.secrets = {
    "mobyklick/identity" = {};
    "mobyklick/password" = {};
  };

  sops.templates."mobyklick/.env".content = ''
    MOBYKLICK_IDENTITY=${config.sops.placeholder."mobyklick/identity"}
    MOBYKLICK_PASSWORD=${config.sops.placeholder."mobyklick/password"}
  '';

  systemd.services.wpa_supplicant.serviceConfig = {BindReadOnlyPaths = ["/run/secrets/mobyklick"];};

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [config.sops.templates."mobyklick/.env".path];
    profiles.mobyklick = {
      connection = {
        id = "mobyklick";
        type = "wifi";
        uuid = "92fb3ace-d8d3-4f6b-94fb-d01599ea15b4";
        interface-name = "wlp3s0";
      };
      wifi = {
        mode = "infrastructure";
        ssid = "Mobyklick(S)";
      };
      wifi-security = {
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        ca-cert = "${../../../files/certs/mobyklick/Root-R3.crt}";
        domain-suffix-match = "mobyklick.de";
        eap = "peap";
        identity = "$MOBYKLICK_IDENTITY";
        password = "$MOBYKLICK_PASSWORD";
        phase2-auth = "mschapv2";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
}
