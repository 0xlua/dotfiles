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
        terminal.shell.program = "fish";
      };
    };

    programs.ghostty = {
      enable = true;
      settings = {
        command = "fish";
        mouse-hide-while-typing = true;
        window-decoration = "none";
      };
    };
  };
}
