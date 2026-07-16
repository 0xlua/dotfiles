{config, ...}: {
  sops.secrets = {
    "eduroam/identity" = {};
    "eduroam/password" = {};
    "eduroam/ca-cert.pem" = {
      format = "binary";
      sopsFile = ../../secrets/eduroam_root_ca.pem;
      mode = "0444";
    };
    "eduroam/client-cert.pem" = {
      format = "binary";
      sopsFile = ../../secrets/eduroam_client_cert.pem;
      mode = "0444";
    };
    "eduroam/private-key.pem" = {
      format = "binary";
      sopsFile = ../../secrets/eduroam_client_key.pem;
      mode = "0444";
    };
  };

  sops.templates."eduroam/.env".content = ''
    EDUROAM_IDENTITY=${config.sops.placeholder."eduroam/identity"}
    EDUROAM_PASSWORD=${config.sops.placeholder."eduroam/password"}
  '';

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [config.sops.templates."eduroam/.env".path];
    profiles.eduroam = {
      connection = {
        id = "eduroam";
        type = "wifi";
        uuid = "e0ca8591-5948-3c69-8474-f35bc56aff0d";
        interface-name = "wlp3s0";
      };
      wifi = {
        ssid = "eduroam";
      };
      wifi-security = {
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        eap = "tls";
        altsubject-matches = "DNS:easyroam.eduroam.de";
        phase1-auth-flags = "0x100";
        identity = "$EDUROAM_IDENTITY";
        ca-cert = "${./easyroam/easyroam_root_ca.pem}";
        # ca-cert = config.sops.secrets."eduroam/ca-cert.pem".path;
        client-cert = "${./easyroam/easyroam_client_cert.pem}";
        # client-cert = config.sops.secrets."eduroam/client-cert.pem".path;
        private-key = "${./easyroam/easyroam_client_key.pem}";
        # private-key = config.sops.secrets."eduroam/private-key.pem".path;
        private-key-password = "$EDUROAM_PASSWORD";
      };
      ipv4.method = "auto";
      ipv6.method = "auto";
    };
  };
}
