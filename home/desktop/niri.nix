{
  pkgs,
  config,
  lib,
  ...
}:
lib.mkIf (config.home-modules.desktop.compositor == "niri") {
  home = {
    packages = with pkgs; [gtklock];
    shellAliases.lock = "gtklock";
  };

  services = {
    swaync.enable = true;
    elephant = {
      enable = true;
      settings.providers.default = [
        "bluetooth"
        # "bookmarks"
        # calc
        "clipboard"
        "desktopapplications"
        "files"
        "menus"
        "playerctl"
        "providerlist"
        "runner"
        "symbols"
        "unicode"
        # "bitwarden"
        "nirisessions"
        "niriactions"
      ];
    };
    walker = {
      enable = true;
      systemd.enable = true;
      settings = {};
    };
  };

  gtk.iconTheme = {
    package = pkgs.colloid-icon-theme;
    name = "Colloid";
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    # extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome pkgs.xdg-desktop-portal-wlr];
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    configPackages = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "gtk";
  };

  wayland.windowManager.niri = {
    enable = true;
    # portalPackage = "TODO";
    settings = {
      binds = {
        "Mod+Shift+Slash".show-hotkey-overlay = {};
        "Mod+Return".spawn-sh = ["GTK_IM_MODULE=simple ghostty"];
        # "Mod+D".spawn = ["centerpiece"];
        "Mod+D".spawn = ["walker"];
        "Mod+Escape".spawn = ["gtklock"];
        XF86AudioRaiseVolume = {
          spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
          _props.allow-when-locked = true;
        };
        XF86AudioLowerVolume = {
          spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];
          _props.allow-when-locked = true;
        };
        XF86AudioMute = {
          spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          _props.allow-when-locked = true;
        };
        XF86AudioMicMute = {
          spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
          _props.allow-when-locked = true;
        };

        "Mod+Q".close-window = {};
        "Mod+O".toggle-overview = {};

        "Mod+H".focus-column-left = {};
        "Mod+J".focus-window-or-workspace-down = {};
        "Mod+K".focus-window-or-workspace-up = {};
        "Mod+L".focus-column-right = {};

        "Mod+Shift+H".move-column-left = {};
        "Mod+Shift+J".move-window-down-or-to-workspace-down = {};
        "Mod+Shift+K".move-window-up-or-to-workspace-up = {};
        "Mod+Shift+L".move-column-right = {};

        "Mod+Ctrl+H".focus-monitor-left = {};
        "Mod+Ctrl+J".focus-monitor-down = {};
        "Mod+Ctrl+K".focus-monitor-up = {};
        "Mod+Ctrl+L".focus-monitor-right = {};

        "Mod+Shift+Ctrl+H".move-window-to-monitor-left = {};
        "Mod+Shift+Ctrl+J".move-window-to-monitor-down = {};
        "Mod+Shift+Ctrl+K".move-window-to-monitor-up = {};
        "Mod+Shift+Ctrl+L".move-window-to-monitor-right = {};

        "Mod+1".focus-workspace = 1;
        "Mod+2".focus-workspace = 2;
        "Mod+3".focus-workspace = 3;
        "Mod+4".focus-workspace = 4;
        "Mod+5".focus-workspace = 5;
        "Mod+6".focus-workspace = 6;
        "Mod+7".focus-workspace = 7;
        "Mod+8".focus-workspace = 8;
        "Mod+9".focus-workspace = 9;

        "Mod+Comma".consume-window-into-column = {};
        "Mod+Period".expel-window-from-column = {};
        "Mod+R".switch-preset-column-width = {};
        "Mod+Shift+R".reset-window-height = {};
        "Mod+F".fullscreen-window = {};
        "Mod+Shift+F".toggle-windowed-fullscreen = {};
        "Mod+C".center-column = {};
        "Mod+T".switch-focus-between-floating-and-tiling = {};
        "Mod+Shift+T".toggle-window-floating = {};

        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        "Print".screenshot = [];
        "Ctrl+Print".screenshot-screen = [];
        "Alt+Print".screenshot-window = [];

        "Mod+Shift+E".quit = {};
        "Mod+Shift+P".power-off-monitors = {};
      };
      hotkey-overlay.skip-at-startup = {};
      prefer-no-csd = {};
      gestures.hot-corners.off = {};
      switch-events.lid-close.spawn = ["gtklock"];
      input = {
        keyboard.xkb = {
          layout = "us";
          variant = "intl";
          options = "caps:escape";
        };
        touchpad = {
          tap = {};
          natural-scroll = {};
        };
        mouse.accel-profile = "flat";
        trackpoint.accel-profile = "flat";
        warp-mouse-to-focus = {};
        focus-follows-mouse._props.max-scroll-amount = "0%";
      };
      cursor.hide-when-typing = {};
      layout = {
        default-column-width = {};
        focus-ring.width = 3;
      };
      _children = [
        {
          window-rule = {
            geometry-corner-radius = 12;
            clip-to-geometry = true;
            open-maximized = true;
          };
        }
      ];
    };
  };
}
