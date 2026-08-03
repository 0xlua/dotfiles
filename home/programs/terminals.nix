{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["alacritty.desktop"];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        window.dynamic_padding = true;
        terminal.shell.program = lib.getExe config.home-modules.user.shell;
      };
    };

    programs.ghostty = {
      enable = true;
      settings = {
        command = lib.getExe config.home-modules.user.shell;
        mouse-hide-while-typing = true;
        window-decoration = "none";
        shell-integration-features = "cursor, ssh-env";
      };
    };
  };
}
