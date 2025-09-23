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
      REDLIB_ROBOTS_DISABLE_INDEXING = "on";
      REDLIB_DEFAULT_THEME = "nord";
      REDLIB_ENABLE_RSS = "on";
      REDLIB_FULL_URL = "reddit.lua.one";
      # Set the default layout (options: card, clean, compact)
      REDLIB_DEFAULT_LAYOUT = "card";
      REDLIB_DEFAULT_SHOW_NSFW = "on";
      # Enable HLS video format by default
      REDLIB_DEFAULT_USE_HLS = "off";
    };
  };
}
