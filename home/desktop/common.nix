{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  options.home-modules.desktop = lib.mkOption {
    type = with lib.types; nullOr (enum ["cosmic" "niri" "wayland"]);
    default = null;
    example = "cosmic";
    description = "What desktop envrionment to use";
  };

  config = lib.mkIf (cfg.desktop != null) {
    sops.secrets."spotify_client_id".mode = "0440";
    home.packages = with pkgs; [
      # file viewer
      oculante # images

      # Desktop
      scrcpy # mirror android screen
      rnote # note taking
      rustdesk-flutter # remote desktop
      yaak # rest api client

      # Wayland stuff
      wl-clipboard
      libnotify
      xwayland-satellite
    ];

    programs.anki = {
      enable = true;
    };

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

    services.syncthing = {
      enable = true;
      settings = {
        folders = {
          "default" = {
            path = "${config.home.homeDirectory}/Sync";
          };
          "njho7-shvne" = {
            path = "${config.home.homeDirectory}/notes";
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
