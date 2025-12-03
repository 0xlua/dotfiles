{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    home = {
      packages = with pkgs; [
        # linkers
        lld
        # wild

        # Languages
        tectonic
        typst
        rustc
        clang
        beancount
        deno

        # LSP
        biome
        beancount-language-server
        texlab
        tinymist
        markdown-oxide
        taplo
        nil
        superhtml
        ltex-ls-plus
        rust-analyzer
        postgres-language-server
        ty

        # Formatter
        typstyle
        alejandra
        stylua
        rustfmt

        # CLI Tools
        hurl # HTTP Requests from files
        just # command runner
        grex # regex generator
        gitu # magit-like git interface

        # json
        jnv # interactive jq filter
        jaq # faster jq clone

        # CSV (want to reduce to one)
        qsv # manipulate csv
        xan # process csv: view, plots, etc
        tabiew # view csv

        # Misc
        sops # nix secrets
        rainfrog # database client
        zola # static site renderer
        fava # beancount web interface
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

    programs.cargo = {
      enable = true;
      settings = {
        target.x86_64-unknown-linux-gnu = {
          linker = "clang";
          rustflags = ["-C" "link-arg=--ld-path=ld.lld"];
        };
      };
    };

    programs.uv = {
      enable = true;
    };

    programs.tex-fmt = {
      enable = true;
      settings = {};
    };
  };
}
