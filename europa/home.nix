{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.ironbar.homeManagerModules.default inputs.niri.homeModules.niri];

  home = {
    packages = with pkgs; [
      # Desktop
      centerpiece
      gtklock

      ulauncher
      anyrun
    ];

    shellAliases = {
      lock = "gtklock";
    };

    sessionVariables = {
      LD_LIBRARY_PATH = "${pkgs.wayland}/lib:${pkgs.libxkbcommon}/lib";
    };
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  programs.ironbar = {
    enable = true;
    package = pkgs.ironbar;
    config = {
      position = "top";
      layer = "overlay";
      margin = {
        top = 8;
        left = 16;
        right = 16;
      };
      start = [
        {
          type = "label";
          label = "Hallo";
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
          type = "network_manager";
          icon_size = 32;
        }
        {
          type = "volume";
          max_volume = 100;
        }
        {
          type = "upower";
        }
        {
          type = "notifications";
          show_count = true;
        }
      ];
    };
    style = "
      @define-color nord0 #2e3440;
      @define-color nord1 #3b4252;
      @define-color nord2 #434c5e;
      @define-color nord3 #4c566a;
      @define-color nord4 #d8dee9;
      @define-color nord5 #e5e9f0;
      @define-color nord6 #eceff4;
      @define-color nord8 #88c0d0;
      @define-color nord9 #81a1c1;
      @define-color nord10 #5e81ac;
      @define-color nord11 #bf616a;
      @define-color nord12 #d08770;
      @define-color nord13 #ebcb8b;
      @define-color nord14 #a3be8c;
      @define-color nord15 #b48ead;

      * {
        font-family: 'Inter Display Medium';
        font-size: 18px;
        border: none;
        border-radius: 12px;
        background-image: none;
        box-shadow: none;
      }

      .background {
          background-color: transparent;
      }

      box, menubar, button, label {
        background-color: @nord1;
        color: @nord6;
        padding: 2px;
      }

      .widget {
        margin: 4px;
      }
    ";
  };

  programs.ncspot = {
    enable = true;
    settings = {
      use_nerdfont = true;
      volnorm = true;
      notify = true;
    };
  };

  programs.wpaperd.enable = true;

  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";
    settings = [
      {
        profile.name = "undocked";
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

  # TODO: flake
  xdg.configFile = {
    "niri/config.kdl".source = ../files/niri/config.kdl;
  };
}
