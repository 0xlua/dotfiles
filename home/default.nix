{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./desktop
    ./programs
    ./editors
    ./dev.home.nix
  ];
  sops = {
    defaultSopsFile = ../secrets.yaml;
    # age.sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    secrets = {
      "atuin/key".mode = "0440";
      "rustypasteToken".mode = "0440";
    };
  };
  nixpkgs.overlays = lib.mkForce null;
  home = {
    username = "lua";
    homeDirectory = "/home/lua";

    sessionVariables = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      MANPAGER = "nvim +Man!";
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
      # terminal viewer
      mdcat # md
      doxx # docx
      # hygg # pdf

      # system
      dysk
      dua # disk usage
      sbctl # secure boot
      uutils-coreutils-noprefix # coreutils

      # tools
      rustypaste-cli # pastebin
      ouch # archiving
      managarr # *arr
      podman-tui

      # logs
      tailspin
      hl-log-viewer
    ];

    stateVersion = "24.05";
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.aerc = {
    enable = true;
    extraConfig.general.unsafe-accounts-conf = true;
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      key_path = config.sops.secrets."atuin/key".path;
      update_check = false;
      sync_address = "https://atuin.lua.one";
      keymap_mode = "vim-insert";
      dotfiles.enabled = false;
      filter_mode = "host";
      inline_height = 20;
      enter_accept = false;
      filter_mode_shell_up_key_binding = "session";
    };
  };

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

  programs.mergiraf.enable = true;

  programs.difftastic = {
    enable = true;
    git.enable = true;
    git.diffToolMode = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "0xlua";
        email = "dev@lukasjordan.com";
      };
      help.autocorrect = "prompt";
      column.ui = "auto";
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      init.defaultBranch = "main";
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      pull.rebase = true;
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "${config.home.homeDirectory}/dotfiles";
  };

  programs.numbat.enable = true;

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
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        addKeysToAgent = "yes";
        serverAliveInterval = 60;
      };
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

  programs.television = {
    enable = true;
    settings = {
      use_nerd_font_icons = true;
    };
  };

  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
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
      show_startup_tips = false;
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
      nn = "$EDITOR ~/notes/QuickNote.md";
      nw = "$EDITOR ~/notes/desy.md";
    };
  };

  services.ssh-agent.enable = true;

  xdg.configFile."rustypaste/config.toml".source = (pkgs.formats.toml {}).generate "rustypaste-cli-config" {
    server = {
      address = "https://share.lua.one";
      auth_token_file = "${config.sops.secrets."rustypasteToken".path}";
    };
    paste.oneshot = false;
    style.prettify = false;
  };
}
