{
  lib,
  config,
  ...
}: let
  cfg = config.home-modules.laptop;
in {
  options.home-modules.laptop.enable = lib.mkEnableOption "Laptop tools";
  config = lib.mkIf cfg.enable {
    services.kanshi = {
      enable = true;
      settings = [
        {
          profile.name = "undocked";
          profile.exec = ["wpaperctl reload"];
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1080@60.049";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "docked";
          profile.exec = ["wpaperctl reload"];
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "Philips Consumer Electronics Company 34M2C6500 AU42423000414";
              position = "0,0";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };
}
