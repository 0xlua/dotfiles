{...}: {
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fd.enable = true;

  programs.ripgrep.enable = true;

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
