{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home = {
    username = "lua";
    homeDirectory = "/home/lua";

    sessionVariables = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
    };

    keyboard = {
      layout = "us";
      variant = "intl";
      options = "caps:escape";
    };

    language = {
      address = "de_DE.UTF-8";
      base = "en_US.UTF-8";
      collate = "en_US.UTF-8";
      ctype = "en_US.UTF-8";
      measurement = "de_DE.UTF-8";
      messages = "en_US.UTF-8";
      monetary = "de_DE.UTF-8";
      name = "de_DE.UTF-8";
      numeric = "de_DE.UTF-8";
      paper = "de_DE.UTF-8";
      telephone = "de_DE.UTF-8";
      time = "de_DE.UTF-8";
    };

    packages = with pkgs; [
      # Desktop
      delfin
      scrcpy
      zed-editor
      rnote
      rustdesk-flutter
      oculante
      psst
      spot
      pwvucontrol
      ventoy
      newsflash

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
      ouch
      grex
      mdcat
      dysk
      dua
      gitu
      jnv
      jaq
      television
      devenv
      sherlock
      managarr
      gitleaks
      sshs
      rustypaste-cli

      # Wayland stuff
      grim
      slurp
      wl-clipboard
      libnotify
      xwayland-satellite
    ];

    stateVersion = "24.05";
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.bat.enable = true;

  programs.bottom = {
    enable = true;
    settings = {
      flags = {
        temperature_type = "celsius";
        battery = true;
        disable_click = true;
        # color = "nord";
      };
    };
  };

  programs.broot = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fd.enable = true;

  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
    policies = {
      DisableTelemetry = true;
      DisablefirefoxStudies = true;
      DisablePocket = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisplayBookmarksToolbar = "always";
      DisplayMenuBar = "never";
      SearchBar = "unified";
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = false;
      };
      Homepage = {
        URL = "https://start.duckduckgo.com";
        Locked = true;
        StartPage = "homepage-locked";
      };
      HttpsOnlyMode = "enabled";
      OfferToSaveLogins = false;
      ShowHomeButton = true;
      Preferences = {
        "browser.contentblocking.category" = "strict";
        "general.autoScroll" = true;
        "extensions.autoDisableScopes" = 0;
      };
    };
    profiles = {
      default = {
        isDefault = true;
        search = {
          default = "DuckDuckGo";
          force = true;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [bitwarden ublock-origin linkding-extension];
      };
      desy = {
        id = 1;
        isDefault = false;
        containersForce = true;
        containers = {
          admin = {
            id = 1;
            color = "red";
          };
          default = {
            id = 2;
            color = "green";
          };
        };
      };
    };
  };

  programs.freetube = {
    enable = true;
    settings = {
      checkForUpdates = false;
      baseTheme = "nordic";
      defaultTheatreMode = true;
      defaultQuality = "1080";
      # allowDashAv1Formats = true;
      hideTrendingVideos = true;
      hidePopularVideos = true;
      hideSubscriptionsLive = true;
      hideSubscriptionsShorts = true;
    };
  };

  programs.fzf.enable = true;

  programs.git = {
    enable = true;
    userName = "0xlua";
    userEmail = "dev@lukasjordan.com";
    difftastic.enable = true;
  };

  programs.git-cliff.enable = true;

  programs.jujutsu = {
    enable = true;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language = [
        {
          name = "python";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "alejandra";};
        }
      ];
    };
    settings = {
      # theme = "nord";
      editor = {
        bufferline = "always";
        true-color = true;
      };
    };
  };

  programs.mpv.enable = true;

  programs.nixvim = {
    enable = true;
    # extraPlugins = [pkgs.vimPlugins.onenord-nvim];
    extraPlugins = [pkgs.vimPlugins.nordic-nvim];
    colorscheme = "nordic";
    clipboard.register = "unnamedplus";
    clipboard.providers.wl-copy.enable = true;
    opts = {
      mouse = "a"; # enable mouse
      number = true; # line numbers
      signcolumn = "yes"; # for git signs
      showmode = false; # let lualine handle this
      fileencoding = "utf-8";
      termguicolors = true;
      cursorline = true;
      laststatus = 3;
      guifont = "Hack NFM:h14"; # font for neovide

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
      smartindent = true;

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
    ];

    # TODO: DAP Debugger
    plugins = {
      web-devicons.enable = true;
      blink-cmp = {
        enable = true;
        settings = {
          snippets = {
            preset = "luasnip";
          };
          completion = {
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
            ghost_text.enabled = true;
          };
        };
      };
      bufferline = {
        enable = true;
        settings.options = {
          close_command = "function(n) Snacks.bufdelete(n) end";
          right_mouse_command = "function(n) Snacks.bufdelete(n) end";
          diagnostics = "nvim_lsp";
        };
      };
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
      luasnip = {
        enable = true;
        fromVscode = [{}];
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
        settings.options.theme = "nordic";
        # TODO: https://www.lazyvim.org/plugins/ui#lualinenvim
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

    # nvim-lspconfig
    # (nvim-treesitter.withPlugins (p: [
    #   p.json
    #   p.lua
    #   p.markdown
    #   p.nix
    #   p.php
    #   p.python
    #   p.rust
    # ]))
    # conform-nvim
    # neogit
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/lua/dotfiles";
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

  programs.rbw = {
    enable = true;
    settings = {
      base_url = "https://vault.lua.one";
      email = "sec@lukasjordan.com";
      pinentry = pkgs.pinentry-tty;
    };
  };

  programs.ripgrep.enable = true;

  programs.ruff = {
    enable = true;
    settings = {};
  };

  programs.ssh = {
    enable = true;
    forwardAgent = true;
    addKeysToAgent = "yes";
    serverAliveInterval = 60;
    matchBlocks = {
      desy = {
        hostname = "bastion.desy.de";
        user = "jordanlu";
        dynamicForwards = [{port = 2280;}];
      };
      galileo = {
        hostname = "lua.one";
      };
      backup = {
        hostname = "u413359.your-storagebox.de";
        user = "u413359";
        port = 23;
      };
      baucons = {
        hostname = "49.12.185.229";
        user = "root";
      };
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zathura = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      ui.pane_frames = {
        rounded_corners = true;
        hide_session_name = true;
      };
      default_shell = "fish";
      # theme = "nord";
      # copy_clipboard = "primary" # default is "system"
      default_layout = "compact";
      mirror_session = true;
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAliases = {
      ls = "eza -al --icons --git --group-directories-first";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window.dynamic_padding = true;
      terminal.shell.program = "fish";
    };
  };

  services.ssh-agent.enable = true;

  services.syncthing = {
    enable = false;
    settings = {
      folders = {
        "default" = {
          path = "/home/lua/Sync";
          devices = ["europa" "pixel"];
        };
        "njho7-shvne" = {
          path = "/home/lua/notes";
          devices = ["europa" "pixel"];
        };
      };
    };
  };

  xdg.configFile."rustypaste/config.toml".source = (pkgs.formats.toml {}).generate "rustypaste-cli-config" {
    server = {
      address = "https://share.lua.one";
      auth_token = "{{rustypaste_token}}";
    };
    paste.oneshot = false;
    style.prettify = false;
  };
}
