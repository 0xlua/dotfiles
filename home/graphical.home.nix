{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      sessionVariables = {
        LD_LIBRARY_PATH = "${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib";
      };

      packages = with pkgs; [
        # Desktop
        delfin
        scrcpy
        zed-editor
        rnote
        rustdesk-flutter
        oculante
        psst
        spot
        pwvucontrol
        ventoy
        newsflash
        signal-desktop

        # Wayland stuff
        grim
        slurp
        wl-clipboard
        libnotify
        xwayland-satellite
      ];
    };

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

    programs.zathura = {
      enable = true;
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window.dynamic_padding = true;
        terminal.shell.program = "fish";
      };
    };

    programs.wpaperd.enable = true;

    services.syncthing = {
      enable = true;
      settings = {
        folders = {
          "default" = {
            path = "/home/lua/Sync";
          };
          "njho7-shvne" = {
            path = "/home/lua/notes";
          };
        };
      };
    };
  };
}
