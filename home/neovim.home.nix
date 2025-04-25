{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager.users.lua = {
    pkgs,
    inputs,
    ...
  }: {
    imports = [
      inputs.nixvim.homeManagerModules.nixvim
    ];
    stylix.targets.nixvim.enable = false;

    programs.neovide.enable = true;
    programs.neovide.settings = {};

    programs.nixvim = {
      enable = true;
      extraPlugins = [pkgs.vimPlugins.onenord-nvim pkgs.vimPlugins.nordic-nvim];
      colorschemes.kanagawa = {
        enable = true;
        settings.background.dark = "dragon";
      };
      colorscheme = "nordic";
      clipboard.register = "unnamedplus";
      clipboard.providers.wl-copy.enable = true;
      opts = {
        mouse = "a"; # enable mouse
        number = true; # line numbers
        signcolumn = "yes"; # for git signs
        showmode = false; # let lualine handle this
        conceallevel = 2; # hide markdown links
        fileencoding = "utf-8";
        termguicolors = true;
        cursorline = true;
        laststatus = 3;
        guifont = "Hack Nerd Font:h14"; # font for neovide
        scrolloff = 10;
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };

        # search
        ignorecase = true;
        smartcase = true;
        incsearch = true;
        hlsearch = true;

        # tab defaults
        expandtab = true;
        shiftwidth = 2;
        softtabstop = 2;
        tabstop = 2;

        showtabline = 2;
        smarttab = true;
        autoindent = true;
        smartindent = true;
        breakindent = true;

        # splits
        splitright = true;
        splitbelow = true;
      };

      globals = {
        t_co = 256;
        background = "dark";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
        filetype_typ = "typst";
        neovide_hide_mouse_when_typing = true;
        neovide_cursor_vfx_mode = "pixiedust";
        mapleader = " ";
        maplocalleader = " ";
        markdown_fenced_languages = ["ts=typescript"];
      };

      keymaps = [
        {
          mode = "n";
          key = "<S-l>";
          action = "<cmd>bnext<CR>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "<S-h>";
          action = "<cmd>bprevious<CR>";
          options.silent = true;
        }
        {
          mode = "n";
          key = "-";
          action = "<cmd>Oil --float<CR>";
          options.desc = "Open Oil File Manager";
        }
      ];

      # TODO: DAP Debugger
      plugins = {
        web-devicons.enable = true;
        blink-cmp = {
          enable = true;
          settings = {
            completion = {
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 200;
              };
              ghost_text.enabled = true;
            };
          };
        };
        friendly-snippets.enable = true;
        conform-nvim = {
          enable = true;
          settings = {
            formatters_by_ft = {
              "_" = ["trim_whitespace"];
              javascript = ["biome" "denofmt"];
              typescript = ["biome" "denofmt"];
              lua = ["stylua"];
              nix = ["alejandra"];
              rust = ["rustfmt"];
              toml = ["taplo"];
              typst = ["typstyle"];
            };
            format_on_save = {
              timeout_ms = 500;
              lsp_fallback = true;
            };
          };
        };
        gitsigns.enable = true;
        lint = {
          enable = true;
          lintersByFt.lua = ["selene"];
        };
        lsp = {
          enable = true;
          inlayHints = true;
          servers = {
            biome.enable = true;
            denols.enable = true;
            # intelephense.enable = true;
            markdown_oxide.enable = true;
            nil_ls.enable = true;
            ruff.enable = true;
            superhtml.enable = true;
            taplo.enable = true;
            texlab.enable = true;
            tinymist.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
          };
        };
        lualine = {
          enable = true;
        };
        neogen = {
          enable = true;
          snippetEngine = "luasnip";
        };
        neorg = {
          enable = true;
          settings.load = {
            "core.defaults".__empty = null;
            "core.concealer".config.icon_preset = "varied";
            "core.dirman".config.workspaces.notes = "/home/lua/notes";
          };
        };
        oil = {
          enable = true;
        };
        snacks = {
          enable = true;
        };
        treesitter = {
          enable = true;
          settings = {
            highlight.enable = true;
          };
        };
        ts-autotag.enable = true;
        ts-comments.enable = true;
        todo-comments.enable = true;
        trouble = {
          enable = true;
          settings.win.position = "right";
          settings.options.use_diagnostic_signs = true;
        };
        which-key = {
          enable = true;
          settings = {
            preset = "helix";
          };
        };
      };

      # neogit
    };
  };
}
