{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.eilmeldung.homeManager.default
  ];

  programs.eilmeldung.enable = true;

  sops.secrets."atuin/key".mode = "0440";

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
}
