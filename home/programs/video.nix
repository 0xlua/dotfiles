{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    home.packages = with pkgs; [delfin];

    programs.yt-dlp.enable = true;

    programs.freetube = {
      enable = true;
      settings = {
        checkForUpdates = false;
        baseTheme = "nordic";
        defaultTheatreMode = true;
        defaultQuality = "1080";
        # allowDashAv1Formats = true;
        hideTrendingVideos = true;
        hidePopularVideos = true;
        hideSubscriptionsLive = true;
        hideSubscriptionsShorts = true;
      };
    };

    programs.mpv.enable = true;
  };
}
