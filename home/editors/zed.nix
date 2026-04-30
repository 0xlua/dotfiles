{config, ...}: {
  programs.zed-editor = {
    enable = config.home-modules.desktop.enable;
    extensions = ["deno" "biome" "nix" "sql" "typst" "html" "markdown-oxide" "latex"];
    userSettings = {
      auto_update = false;
      disable_ai = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      lsp = {
        texlab.settings = config.programs.helix.languages.language-server.texlab.config;
        tinymist.settings = {
          exportPdf = "onSave";
          outputPath = "$root/$name";
        };
        deno.settings = config.programs.helix.languages.language-server.deno-lsp.config;
      };
      languages = {
        Python = {
          language_servers = ["ruff" "ty" "!basedpyright"];
        };
        Nix = {
          language_servers = ["nil" "!nixd"];
          formatter.external = {
            command = "alejandra";
            arguments = ["--quiet" "--"];
          };
        };
        LaTeX = {
          formatter.external = {
            command = "tex-fmt";
            arguments = ["--stdin"];
          };
        };
      };
      use_smartcase_search = true;
      helix_mode = true;
    };
  };
}
