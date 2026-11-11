{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.arr.ytdl-sub;
in {
  options.modules.roles.server.arr.ytdl-sub.enable = lib.mkEnableOption "ytdl-sub";

  config = lib.mkIf cfg.enable {
    systemd.services."ytdl-sub-default".serviceConfig.ProtectHome = lib.mkForce false;

    services.ytdl-sub = let
      path = "/home/lua/media/youtube";
    in {
      user = "lua";
      group = "users";
      instances.default = {
        enable = true;
        schedule = "0/6:0";
        readWritePaths = [path];
        subscriptions = {
          "__preset__" = {overrides.tv_show_directory = path;};
          "Jellyfin TV Show by Date | Only Recent | Max 2160p" = {
            "Linus Tech Tips" = "https://www.youtube.com/@LinusTechTips";
            "Tom Scott" = "https://www.youtube.com/@TomScottGo";
            "Practical Engineering" = "https://www.youtube.com/@PracticalEngineeringChannel";
            "Technology Connections" = "https://www.youtube.com/@TechnologyConnections";
            "James Hoffmann" = "https://www.youtube.com/@jameshoffmann";
            "Veritasium" = "https://www.youtube.com/@veritasium";
            "Benn Jordan" = "https://www.youtube.com/@BennJordan";
          };
        };
      };
    };
  };
}
