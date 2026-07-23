{
  config,
  lib,
  hostName,
  ...
}: {
  sops.secrets = {
    syncthing_gui_password = {};
    syncthing_key = {
      format = "binary";
      sopsFile = ../../secrets/syncthing/${hostName}.pem;
      mode = "0600";
    };
  };

  services.syncthing = {
    inherit (config.home-modules.desktop) enable;
    cert = "${../../files/certs/syncthing/${hostName}.pem}";
    key = config.sops.secrets.syncthing_key.path;
    guiCredentials = {
      inherit (config.home) username;
      passwordFile = config.sops.secrets.syncthing_gui_password.path;
    };
    # tray.enable = true;
    settings = {
      devices = {
        "callisto".id = "2LTFSWX-34JELVJ-K56YS3C-2H3V2XN-U6XDCFP-HQ4OHZL-C3CPZ5I-3JA5NQE";
        "pixel".id = "FUFYI35-GNBR3HW-OP3LWRW-Y7K4ANH-YU7CZ3X-IBBAUWD-CIWJIWR-R7F3KQV";
      };
      folders = let
        devices = lib.attrNames config.services.syncthing.settings.devices;
      in {
        "default" = {
          inherit devices;
          path = "${config.home.homeDirectory}/Sync";
        };
        "njho7-shvne" = {
          inherit devices;
          label = "notes";
          path = "${config.home.homeDirectory}/notes";
        };
      };
      options = {
        localAnnounceEnabled = true;
        urAccepted = -1;
      };
    };
  };
}
