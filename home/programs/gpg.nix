{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.home-modules.gpg;
in {
  options.home-modules.gpg.enable = lib.mkEnableOption "encryption & signing with gpg";

  config = let
    email = "moin@lua.one"; # TODO: config option in home-modules
  in
    lib.mkIf cfg.enable {
      programs.gpg = {
        enable = true;
        settings.encrypt-to = email;
        publicKeys = let
          trust = 5;
        in
          map (source: {inherit source trust;}) [
            ../../files/certs/gpg/lukasjordan.com/hu/aeii9rmagouy1owpp7e5ftpxjof7h41n # hi@lukasjordan.com
            ../../files/certs/gpg/lukasjordan.com/hu/ze6x9uruirzyt6bcgxni5ndsc569g3fq # moin@lukasjordan.com
            ../../files/certs/gpg/lua.one/hu/ze6x9uruirzyt6bcgxni5ndsc569g3fq # moin@lua.one
          ];
      };

      services.gpg-agent = {
        enable = true;
        pinentry = {
          package = pkgs.wayprompt;
          program = "pinentry-wayprompt";
        };
      };
    };
}
