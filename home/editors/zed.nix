{
  programs.zed-editor = {
    enable = true;
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
