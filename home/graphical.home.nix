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
  sops.secrets."liberaSasl" = {
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
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd
        glibc
        libGL
        patchelf
      ];
    };
  };
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        # Desktop
        delfin
        scrcpy
        rnote
        rustdesk-flutter
        oculante
        yaak

        # Wayland stuff
        wl-clipboard
        libnotify
        xwayland-satellite

        # terminal
        viu
      ];
    };

    programs.anki = {
      enable = true;
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

    programs.ghostty = {
      enable = true;
      settings = {
        command = "fish";
      };
    };

    programs.gurk-rs = {
      enable = true;
      settings = {
        signal_db_path = "${config.users.users.lua.home}/.local/share/gurk/signal-db";
        first_name_only = false;
        show_receipts = true;
        notifications = true;
        bell = true;
        colored_messages = false;
        default_keybindings = true;
        user.name = "Lukas";
        sqlite = {
          url = "sqlite://${config.users.users.lua.home}/.local/share/gurk/gurk.sqlite";
          _preserve_unencryped = false;
        };
      };
    };

    programs.halloy = {
      enable = true;
      settings = {
        buffer.channel.topic = {
          enabled = true;
        };
        servers.liberachat = {
          channels = ["#voidlinux"];
          nickname = "lua";
          server = "irc.libera.chat";
          sasl.plain = {
            username = "lua";
            password_file = config.sops.secrets."liberaSasl".path;
          };
        };
      };
    };

    programs.zed-editor = {
      enable = true;
      extensions = ["nix"];
      userSettings = {
        auto_update = false;
        disable_ai = true;
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
            path = "${config.users.users.lua.home}/Sync";
          };
          "njho7-shvne" = {
            path = "${config.users.users.lua.home}/notes";
          };
        };
      };
    };

    services.wpaperd.enable = true;

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    xdg.terminal-exec = {
      enable = true;
      settings.default = ["alacritty.desktop"];
    };

    xdg.mimeApps = {
      enable = true;
      associations.removed = {"application/pdf" = ["com.github.flxzt.rnote.desktop"];};
      associations.added = {"application/pdf" = ["firefox.desktop"];};
      defaultApplications = let
        browser = ["firefox.desktop"];
        imageViewer = ["oculante.desktop"];
        videoPlayer = ["mpv.desktop"];
      in {
        # XDG MIME types
        "application/json" = browser;

        "application/pdf" = ["org.pwmt.zathura.desktop"];

        # Images
        "image/jpeg" = imageViewer;
        "image/png" = imageViewer;
        # "image/gif" = imageViewer;
        "image/gif" = videoPlayer;
        "image/webp" = imageViewer;
        "image/tiff" = imageViewer;
      };
    };
  };
}
