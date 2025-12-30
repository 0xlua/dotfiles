{config, ...}: {
  programs.zed-editor = {
    enable = config.home-modules.desktop.enable;
    extensions = ["nix"];
    userSettings = {
      auto_update = false;
      disable_ai = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      languages = {
        Nix.formatter.external = {
          command = "alejandra";
          arguments = ["--quiet" "--"];
        };
      };
      use_smartcase_search = true;
      vim_mode = true;
    };
  };
}
