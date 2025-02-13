{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      username = "lua";
      homeDirectory = "/home/lua";

      sessionVariables = {
        LANGUAGE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        DO_NOT_TRACK = 1;
      };

      keyboard = {
        layout = "us";
        variant = "intl";
        options = "caps:escape";
      };

      language = {
        address = "de_DE.UTF-8";
        base = "en_US.UTF-8";
        collate = "en_US.UTF-8";
        ctype = "en_US.UTF-8";
        measurement = "de_DE.UTF-8";
        messages = "en_US.UTF-8";
        monetary = "de_DE.UTF-8";
        name = "de_DE.UTF-8";
        numeric = "de_DE.UTF-8";
        paper = "de_DE.UTF-8";
        telephone = "de_DE.UTF-8";
        time = "de_DE.UTF-8";
      };

      packages = with pkgs; [
        ouch
        mdcat
        numbat
        dysk
        dua
        television
        sherlock
        managarr
        gitleaks
        sshs
        rustypaste-cli
      ];

      stateVersion = "24.05";
    };

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.bat.enable = true;

    programs.bottom = {
      enable = true;
      settings = {
        flags = {
          temperature_type = "celsius";
          battery = true;
          disable_click = true;
          # color = "nord";
        };
      };
    };

    programs.broot = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fd.enable = true;

    programs.fzf.enable = true;

    programs.git = {
      enable = true;
      userName = "0xlua";
      userEmail = "dev@lukasjordan.com";
      difftastic.enable = true;
    };

    programs.helix = {
      enable = true;
      defaultEditor = true;
      languages = {
        language = [
          {
            name = "python";
            auto-format = true;
          }
          {
            name = "nix";
            auto-format = true;
            formatter = {command = "alejandra";};
          }
        ];
      };
      settings = {
        # theme = "nord";
        editor = {
          bufferline = "always";
          true-color = true;
        };
      };
    };

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/lua/dotfiles";
    };

    programs.rbw = {
      enable = true;
      settings = {
        base_url = "https://vault.lua.one";
        email = "sec@lukasjordan.com";
        pinentry = pkgs.pinentry-tty;
      };
    };

    programs.ripgrep.enable = true;

    programs.ssh = {
      enable = true;
      forwardAgent = true;
      addKeysToAgent = "yes";
      serverAliveInterval = 60;
      matchBlocks = {
        desy = {
          hostname = "bastion.desy.de";
          user = "jordanlu";
          dynamicForwards = [{port = 2280;}];
        };
        galileo = {
          hostname = "lua.one";
        };
        backup = {
          hostname = "u413359.your-storagebox.de";
          user = "u413359";
          port = 23;
        };
        baucons = {
          hostname = "49.12.185.229";
          user = "root";
        };
      };
    };

    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        ui.pane_frames = {
          rounded_corners = true;
          hide_session_name = true;
        };
        default_shell = "fish";
        # theme = "nord";
        # copy_clipboard = "primary" # default is "system"
        default_layout = "compact";
        mirror_session = true;
      };
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
    };

    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      shellAliases = {
        ls = "eza -al --icons --git --group-directories-first";
      };
    };

    services.ssh-agent.enable = true;

    xdg.configFile."rustypaste/config.toml".source = (pkgs.formats.toml {}).generate "rustypaste-cli-config" {
      server = {
        address = "https://share.lua.one";
        # TODO: https://github.com/orhun/rustypaste-cli/pull/171
        auth_token = "{{rustypaste_token}}";
      };
      paste.oneshot = false;
      style.prettify = false;
    };
  };
}
