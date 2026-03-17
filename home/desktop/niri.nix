{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules;
in {
  imports = [
    inputs.ironbar.homeManagerModules.default
    inputs.niri.homeModules.niri
  ];
  config = lib.mkIf (cfg.desktop.compositor == "niri") {
    home = {
      packages = with pkgs; [
        # Desktop
        centerpiece
        gtklock
      ];

      shellAliases = {
        lock = "gtklock";
      };
    };

    programs.niri = {
      enable = true;
      package = pkgs.niri;
      settings = {
        binds = with config.lib.niri.actions; {
          "Mod+Shift+Slash".action = show-hotkey-overlay;
          "Mod+Return".action = spawn-sh "GTK_IM_MODULE=simple ghostty";
          "Mod+D".action = spawn "centerpiece";
          "Mod+Escape".action = spawn "gtklock";
          XF86AudioRaiseVolume = {
            action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+";
            allow-when-locked = true;
          };
          XF86AudioLowerVolume = {
            action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-";
            allow-when-locked = true;
          };
          XF86AudioMute = {
            action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
            allow-when-locked = true;
          };
          XF86AudioMicMute = {
            action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
            allow-when-locked = true;
          };

          "Mod+Q".action = close-window;
          "Mod+O".action = toggle-overview;

          "Mod+H".action = focus-column-left;
          "Mod+J".action = focus-window-or-workspace-down;
          "Mod+K".action = focus-window-or-workspace-up;
          "Mod+L".action = focus-column-right;

          "Mod+Shift+H".action = move-column-left;
          "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
          "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
          "Mod+Shift+L".action = move-column-right;

          "Mod+Ctrl+H".action = focus-monitor-left;
          "Mod+Ctrl+J".action = focus-monitor-down;
          "Mod+Ctrl+K".action = focus-monitor-up;
          "Mod+Ctrl+L".action = focus-monitor-right;

          "Mod+Shift+Ctrl+H".action = move-window-to-monitor-left;
          "Mod+Shift+Ctrl+J".action = move-window-to-monitor-down;
          "Mod+Shift+Ctrl+K".action = move-window-to-monitor-up;
          "Mod+Shift+Ctrl+L".action = move-window-to-monitor-right;

          "Mod+1".action = focus-workspace 1;
          "Mod+2".action = focus-workspace 2;
          "Mod+3".action = focus-workspace 3;
          "Mod+4".action = focus-workspace 4;
          "Mod+5".action = focus-workspace 5;
          "Mod+6".action = focus-workspace 6;
          "Mod+7".action = focus-workspace 7;
          "Mod+8".action = focus-workspace 8;
          "Mod+9".action = focus-workspace 9;

          "Mod+Comma".action = consume-window-into-column;
          "Mod+Period".action = expel-window-from-column;
          "Mod+R".action = switch-preset-column-width;
          "Mod+Shift+R".action = reset-window-height;
          "Mod+F".action = fullscreen-window;
          "Mod+Shift+F".action = toggle-windowed-fullscreen;
          "Mod+C".action = center-column;
          "Mod+T".action = switch-focus-between-floating-and-tiling;
          "Mod+Shift+T".action = toggle-window-floating;

          "Mod+Minus".action = set-column-width "-10%";
          "Mod+Equal".action = set-column-width "+10%";
          "Mod+Shift+Minus".action = set-window-height "-10%";
          "Mod+Shift+Equal".action = set-window-height "+10%";

          "Print".action.screenshot = [];
          "Ctrl+Print".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];

          "Mod+Shift+E".action = quit;
          "Mod+Shift+P".action = power-off-monitors;
        };
        hotkey-overlay.skip-at-startup = true;
        prefer-no-csd = true;
        gestures.hot-corners.enable = false;
        switch-events.lid-close.action.spawn = "gtklock";
        input = {
          keyboard.xkb = {
            layout = "us";
            variant = "intl";
            options = "caps:escape";
          };
          touchpad = {
            tap = true;
            natural-scroll = true;
          };
          mouse.accel-profile = "flat";
          trackpoint.accel-profile = "flat";
          warp-mouse-to-focus.enable = true;
          focus-follows-mouse = {
            enable = true;
            max-scroll-amount = "0%";
          };
        };
        cursor.hide-when-typing = true;
        layout = {
          default-column-width = {};
          focus-ring.width = 3;
        };
        window-rules = [
          {
            geometry-corner-radius = {
              bottom-left = 12.0;
              bottom-right = 12.0;
              top-left = 12.0;
              top-right = 12.0;
            };
            clip-to-geometry = true;
            open-maximized = true;
          }
        ];
      };
    };

    programs.ironbar = {
      enable = true;
      systemd = true;
      package = pkgs.ironbar;
      config = {
        position = "top";
        height = 24;
        layer = "overlay";
        start = [
          {
            type = "workspaces";
          }
        ];
        center = [
          {
            type = "clock";
            format = "%H:%M";
          }
        ];
        end = [
          {
            type = "tray";
          }
          {
            type = "network_manager";
            types_blacklist = ["loopback" "bridge"];
          }
          {
            type = "volume";
            max_volume = 100;
          }
          {
            type = "battery";
          }
          {
            type = "notifications";
            show_count = true;
          }
        ];
      };
      style = "
        :root {
            --color-dark-primary: #1c1c1c;
            --color-dark-secondary: #2d2d2d;
            --color-white: #fff;
            --color-active: #6699cc;
            --color-urgent: #8f0a0a;

            --margin-lg: 1em;
            --margin-sm: 0.5em;
        }

        * {
            border-radius: 0;
            border: none;
            box-shadow: none;
            background-image: none;
            font-family: monospace;
        }

        scale > trough {
            background-color: var(--color-dark-secondary);
        }

        scale > trough > highlight {
            background-color: var(--color-active);
            border-style: solid;
            border-color: var(--color-active);
            border-width: 0.2em;
        }

        scale > trough > slider {
            background-color: var(--color-white);
        }

        switch > slider {
            background-color: var(--color-white);
        }

        switch:checked {
            background-color: var(--color-active);
        }

        switch:not(:checked) {
          background-color: var(--color-dark-secondary);
        }

        #bar, popover, popover contents, calendar {
            background-color: var(--color-dark-primary);
        }

        box, button, label {
            background-color: #0000;
            color: var(--color-white);
        }

        button {
            padding-left: var(--margin-sm);
            padding-right: var(--margin-sm);
        }

        button:hover, button:active {
            background-color: var(--color-dark-secondary);
        }

        #end > * + * {
            margin-left: var(--margin-lg);
        }

        .sysinfo > * + * {
            margin-left: var(--margin-sm);
        }

        .clock {
            font-weight: bold;
        }

        .popup-clock .calendar-clock {
            font-size: 2.0em;
        }

        .popup-clock .calendar .today {
            background-color: var(--color-active);
        }

        .workspaces .item.visible {
            box-shadow: inset 0 -1px var(--color-white);
        }

        .workspaces .item.focused {
            box-shadow: inset 0 -1px var(--color-active);
            background-color: var(--color-dark-secondary);
        }

        .workspaces .item.urgent {
            background-color: var(--color-urgent);
        }";
    };

    services.kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          profile.name = "undocked";
          profile.exec = ["wpaperctl reload"];
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              mode = "1920x1080@60.049";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "work";
          profile.exec = ["wpaperctl reload"];
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "Dell Inc. DELL U2412M YPPY07CL112U";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "Dell Inc. DELL U2412M YPPY077J5X3S";
              position = "1920,0";
              scale = 1.0;
            }
          ];
        }
        {
          profile.name = "002";
          profile.exec = ["wpaperctl reload"];
          profile.outputs = [
            {
              criteria = "eDP-1";
              position = "0,0";
              mode = "1920x1080@60.049";
              scale = 1.0;
            }
            {
              criteria = "Samsung Electric Company SAMSUNG 0x01000600";
              position = "0,-1080";
              mode = "1920x1080@60.000";
              scale = 1.0;
            }
          ];
        }
      ];
    };

    services.swaync = {
      enable = true;
    };
  };
}
