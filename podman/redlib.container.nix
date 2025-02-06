{...}: {
  virtualisation.oci-containers.containers.redlib = {
    image = "quay.io/redlib/redlib:latest";
    autoStart = true;
    user = "nobody:nogroup";
    capabilities = {ALL = false;};
    extraOptions = [
      "--read-only"
    ];
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    environment = {
      REDLIB_SFW_ONLY = "off";
      REDLIB_BANNER = "";
      REDLIB_ROBOTS_DISABLE_INDEXING = "on";
      REDLIB_PUSHSHIFT_FRONTEND = "undelete.pullpush.io";
      REDLIB_DEFAULT_THEME = "nord";
      REDLIB_ENABLE_RSS = "on";
      REDLIB_DEFAULT_FRONT_PAGE = "default";
      # Set the default layout (options: card, clean, compact)
      REDLIB_DEFAULT_LAYOUT = "card";
      REDLIB_DEFAULT_WIDE = "off";
      REDLIB_DEFAULT_POST_SORT = "hot";
      REDLIB_DEFAULT_COMMENT_SORT = "confidence";
      REDLIB_DEFAULT_BLUR_SPOILER = "off";
      REDLIB_DEFAULT_SHOW_NSFW = "on";
      REDLIB_DEFAULT_BLUR_NSFW = "off";
      # Enable HLS video format by default
      REDLIB_DEFAULT_USE_HLS = "off";
      REDLIB_DEFAULT_HIDE_HLS_NOTIFICATION = "off";
      REDLIB_DEFAULT_AUTOPLAY_VIDEOS = "off";
      # REDLIB_DEFAULT_SUBSCRIPTIONS=selfhosted
      REDLIB_DEFAULT_HIDE_AWARDS = "off";
      REDLIB_DEFAULT_HIDE_SIDEBAR_AND_SUMMARY = "off";
      REDLIB_DEFAULT_DISABLE_VISIT_REDDIT_CONFIRMATION = "off";
      REDLIB_DEFAULT_HIDE_SCORE = "off";
      REDLIB_DEFAULT_FIXED_NAVBAR = "on";
    };
  };
}
