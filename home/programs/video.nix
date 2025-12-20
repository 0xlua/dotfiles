{pkgs, ...}: {
  home.packages = with pkgs; [delfin];

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
}
