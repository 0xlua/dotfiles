{...}: {
  virtualisation.oci-containers.containers.littlelink = {
    image = "ghcr.io/techno-tim/littlelink-server:latest";
    autoStart = true;
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    environment = {
      META_TITLE = "Lua";
      META_DESCRIPTION = "hello there.";
      META_AUTHOR = "Lukas Jordan";
      META_KEYWORDS = "SelfHosted, Dashboard, Links";
      META_INDEX_STATUS = "all";
      THEME = "Dark";
      LANG = "en";
      OG_SITE_NAME = "Lua";
      OG_TITLE = "Lua";
      OG_DESCRIPTION = "hello there.";
      OG_URL = "https://lua.one";
      OG_IMAGE = "https://ftp.lukasjordan.com/avatar_400x400.png";
      OG_IMAGE_WIDTH = "400";
      OG_IMAGE_HEIGHT = "400";
      FAVICON_URL = "https://ftp.lukasjordan.com/avatar_200x200.png";
      AVATAR_URL = "https://ftp.lukasjordan.com/avatar_200x200.png";
      AVATAR_2X_URL = "https://ftp.lukasjordan.com/avatar_400x400.png";
      AVATAR_ALT = "Lua Profile Pic";
      NAME = "Lua";
      BIO = "hello there.";
      BUTTON_ORDER = "GITHUB,FORGEJO,LETTERBOXD,STEAM,EMAIL";
      GITHUB = "https://github.com/0xlua";
      FORGEJO = "https://codeberg.org/0xlua";
      LETTERBOXD = "https://letterboxd.com/Luatex/";
      STEAM = "https://steamcommunity.com/id/lua01/";
      # MATRIX=
      # SIMPLEX=
      EMAIL = "moin@lukasjordan.com";
      FOOTER = "Lua © 2025";
    };
  };
}
