{config, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language = [
        {
          name = "latex";
          language-servers = ["texlab" "ltex-ls-plus"];
          auto-format = true;
          formatter = {command = "tex-fmt";};
        }
        {
          name = "python";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "alejandra";};
        }
        {
          name = "json";
          auto-format = true;
          language-servers = ["biome"];
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = ["biome"];
        }
        {
          name = "typescript";
          auto-format = true;
          language-servers = [{name = "deno-lsp";} "biome"];
        }
        {
          name = "beancount";
          auto-format = true;
          language-servers = [{name = "beancount-language-server";}];
        }
      ];
      language-server = {
        biome = {
          command = "biome";
          args = ["lsp-proxy"];
        };
        deno-lsp = {
          command = "deno";
          args = ["lsp"];
          config.deno = {
            enable = true;
            unstable = true;
            suggest.imports.hosts = {"https://deno.land" = true;};
            inlayHints.parameterNames.enabled = "all";
            inlayHints.parameterTypes.enabled = true;
            inlayHints.variableTypes.enabled = true;
            inlayHints.propertyDeclarationTypes.enabled = true;
            inlayHints.functionLikeReturnTypes.enabled = true;
            inlayHints.enumMemberValues.enabled = true;
          };
        };
        beancount-language-server = {
          command = "beancount-language-server";
          args = ["--stdio"];
          config.journal_file = "${config.home.homeDirectory}/notes/accounts.bean";
        };
        texlab.config.texlab = {
          forwardSearch = {
            executable = "zathura";
            args = ["--synctex-forward" "%l:1:%f" "%p"];
          };
          build = {
            onSave = true;
            forwardSearchAfter = true;
            executable = "tectonic";
            args = [
              "-X"
              "build"
              "--keep-logs"
              "--keep-intermediates"
            ];
          };
        };
      };
    };
    settings = {
      # theme = "nord";
      keys.normal = {
        ret = "goto_word";
        space.o = "file_picker_in_current_buffer_directory";
      };
      editor = {
        lsp.display-inlay-hints = true;
        inline-diagnostics.cursor-line = "hint";
        cursorline = true;
        bufferline = "always";
        true-color = true;
      };
    };
  };
}
