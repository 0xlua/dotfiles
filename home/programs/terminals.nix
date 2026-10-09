{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.home-modules.desktop.enable {
    xdg.terminal-exec = {
      enable = true;
      settings.default = ["foot.desktop"];
    };

    programs.foot.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        window.dynamic_padding = true;
        terminal.shell.program = lib.getExe config.home-modules.user.shell;
      };
    };
  };
}
