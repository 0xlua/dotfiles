{...}: {
  imports = [./hardware-configuration.nix];

  modules = {
    hostname = "ganymede";
    user.name = "lua";
    samba = {
      enable = true;
      mounts = let
        specialOptions = [
          "nobrl"
          "x-systemd.requires=network-online.target"
        ];
      in [
        {
          source = "//io.internal/media";
          target = "/home/lua/media";
          inherit specialOptions;
        }
        {
          source = "//io.internal/scanner";
          target = "/home/lua/scanner";
          inherit specialOptions;
        }
        {
          source = "//io.internal/lua/Music";
          target = "/home/lua/Music";
          inherit specialOptions;
        }
      ];
    };
    roles = {
      server = {
        enable = true;
        jellyfin.enable = true;
        jellyfin.publiclyAccessible = true;
        calibre.enable = true;
        mafl.enable = true;
        koito.enable = true;
        paperless.enable = true;
        homeassistant.enable = true;
        musicassistant.enable = true;
        arr.enable = true;
        arr.deluge.enable = true;
        arr.flaresolverr.enable = true;
        arr.prowlarr.enable = true;
        arr.radarr.enable = true;
        arr.sonarr.enable = true;
        arr.bazarr.enable = true;
      };
    };
  };

  system.stateVersion = "25.11"; # Don't change
}
