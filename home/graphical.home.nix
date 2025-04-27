{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  sops.secrets."spotify_client_id" = {
    mode = "0440";
    owner = config.users.users.lua.name;
    group = config.users.users.lua.group;
  };
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        wayland
        libxkbcommon
      ];
    };
  };
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        # Desktop
        anki-bin
        delfin
        scrcpy
        rnote
        rustdesk-flutter
        oculante
        pwvucontrol
        ventoy
        newsflash
        signal-desktop
        buffer
        yaak

        # Wayland stuff
        grim
        slurp
        wl-clipboard
        libnotify
        xwayland-satellite

        # terminal
        viu
        gurk-rs
        asak
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

    programs.spotify-player = {
      enable = true;
      settings = {
        client_id_command = {
          command = "cat";
          args = [config.sops.secrets."spotify_client_id".path];
        };
      };
    };

    programs.zathura = {
      enable = true;
      options = {
        recolor = true;
        synctex = true;
        synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
      };
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window.dynamic_padding = true;
        terminal.shell.program = "fish";
      };
    };

    programs.zed-editor = {
      enable = true;
      extensions = ["nix"];
      userSettings = {
        auto_update = false;
        assistant.enabled = false;
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        languages = {
          Nix.formatter.external = {
            command = "alejandra";
            arguments = ["--quiet" "--"];
          };
        };
        use_smartcase_search = true;
        vim_mode = true;
      };
    };

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

    services.wpaperd.enable = true;

    xdg.mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["firefox.desktop"];
        imageViewer = ["oculante.desktop"];
        videoPlayer = ["mpv.desktop"];
      in {
        # XDG MIME types
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/xhtml+xml" = browser;
        "text/html" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/chrome" = browser;
        "x-scheme-handler/ftp" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/unknown" = browser;

        "application/json" = browser;

        "application/pdf" = ["org.pwmt.zathura.desktop"];

        # Images
        "image/jpeg" = imageViewer;
        "image/png" = imageViewer;
        # "image/gif" = imageViewer;
        "image/gif" = videoPlayer;
        "image/webp" = imageViewer;
        "image/tiff" = imageViewer;
        "image/x-tga" = imageViewer;
        "image/vnd-ms.dds" = imageViewer;
        "image/x-dds" = imageViewer;
        "image/bmp" = imageViewer;
        "image/vnd.microsoft.icon" = imageViewer;
        "image/vnd.radiance" = imageViewer;
        "image/x-exr" = imageViewer;
        "image/x-portable-bitmap" = imageViewer;
        "image/x-portable-graymap" = imageViewer;
        "image/x-portable-pixmap" = imageViewer;
        "image/x-portable-anymap" = imageViewer;
        "image/x-qoi" = imageViewer;
        "image/svg+xml" = imageViewer;
        "image/svg+xml-compressed" = imageViewer;
        "image/avif" = imageViewer;
        "image/heic" = imageViewer;
        "image/jxl" = imageViewer;
      };
    };
  };
}
