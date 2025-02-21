{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        # Languages
        tectonic
        typst

        # LSP
        biome
        texlab
        tinymist
        markdown-oxide
        taplo
        nil
        superhtml

        # Formatter
        typstyle
        alejandra
        stylua

        # Linter
        selene

        # CLI Tools
        hurl
        xh
        grex
        gitu
        jnv
        jaq
        qsv
        tabiew
        devenv
        rainfrog
      ];
    };

    programs.git-cliff.enable = true;

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };

    programs.gh-dash.enable = true;

    programs.jujutsu = {
      enable = true;
    };

    programs.papis = {
      enable = true;
      libraries = {
        "default" = {
          isDefault = true;
          settings.dir = "~/papers/default";
        };
        "bachelor" = {
          settings.dir = "~/papers/bachelor";
        };
      };
      settings = {
        editor = "hx";
        file-browser = "yazi";
        add-edit = true;
      };
    };

    programs.ruff = {
      enable = true;
      settings = {};
    };
  };
}
