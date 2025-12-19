{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
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
    colorscheme = "onenord";
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
      showtabline = 0;
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

    lsp = {
      inlayHints.enable = true;
      servers = {
        biome.enable = true;
        denols.enable = true;
        markdown_oxide.enable = true;
        nil_ls.enable = true;
        ruff.enable = true;
        rust_analyzer.enable = true;
        stylua.enable = true;
        superhtml.enable = true;
        taplo.enable = true;
        texlab.enable = true;
        tinymist.enable = true;
        ty.enable = true;
      };
    };

    plugins = {
      blink-cmp = {
        enable = true;
        settings = {
          signature.enabled = true;
          completion = {
            menu.border = "rounded";
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
            ghost_text.enabled = true;
          };
        };
      };
      friendly-snippets.enable = true;
      lspconfig.enable = true;
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
      web-devicons.enable = true; # needed for fzf-lua, trouble, lualine
      fzf-lua = {
        enable = true;
        keymaps = {
          "<leader>f" = {
            action = "files";
            options.desc = "List files";
          };
          "<leader>b" = {
            action = "buffers";
            options.desc = "List buffers";
          };
          "<leader>/" = {
            action = "live_grep";
            options.desc = "Search Project";
          };
          "<leader>gf" = {
            action = "git_files";
            options.desc = "List Git Files";
          };
          "<leader>gs" = {
            action = "git_status";
            options.desc = "Show Git Status";
          };
          "<leader>l" = {
            action = "builtin";
            options.desc = "List Fuzzy Finders";
          };
        };
      };
      gitsigns.enable = true;
      lualine.enable = true;
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "<A-o>";
              node_incremental = "<A-o>";
              scope_incremental = false;
              node_decremental = "<A-i>";
            };
          };
        };
      };
      ts-autotag.enable = true;
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
  };
}
