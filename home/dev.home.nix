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
        rustc
        lld
        clang

        # LSP
        biome
        texlab
        tinymist
        markdown-oxide
        taplo
        nil
        superhtml
        ltex-ls-plus
        rust-analyzer

        # Formatter
        typstyle
        alejandra
        stylua
        rustfmt

        # Linter
        selene

        # project / package manager
        uv
        cargo

        # CLI Tools
        hurl
        xh
        grex
        gitu
        jnv
        jaq
        qsv
        sops
        tabiew
        rainfrog
        zola
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

    programs.tex-fmt = {
      enable = true;
      settings = {};
    };

    home.file.".cargo/config.toml".source = (pkgs.formats.toml {}).generate "cargo-config" {
      target.x86_64-unknown-linux-gnu = {
        linker = "clang";
        rustflags = ["-C" "link-arg=--ld-path=ld.lld"];
      };
    };
  };
}
