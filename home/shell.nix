{
  lib,
  config,
  ...
}: {
  programs.bat = {
    enable = true;
    config.style = "plain";
  };

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
      default_shell = lib.getExe config.home-modules.user.shell;
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
      set -g fish_key_bindings fish_vi_key_bindings # Vi Mode
    '';
    shellAliases = {
      ls = "eza -al --icons --git --group-directories-first";
      nn = "$EDITOR ~/notes/QuickNote.md";
    };
  };
}
