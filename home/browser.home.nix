{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    # imports = [];
    stylix.targets.firefox.profileNames = ["default" "desy"];
    xdg.configFile."tridactyl/tridactylrc".source = ../tridactylrc;
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
      nativeMessagingHosts = [pkgs.tridactyl-native];
      policies = {
        DisplayMenuBar = "never";
        SearchBar = "unified";
        TranslateEnabled = false;
        PictureInPicture.Enabled = false;
        Preferences = {
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.ml.chat.page.footerBadge" = false;
          "browser.ml.chat.page.menuBadge " = false;
          "browser.ml.chat.shortcuts" = false;
          "browser.ml.chat.shortcuts.custom" = false;
          "browser.ml.chat.sidebar" = false;
          "browser.ml.checkForMemory " = false;
          "browser.ml.enable" = false;
          "sidebar.verticalTabs" = true;
        };
      };
      profiles = {
        default = {
          isDefault = true;
          search = {
            default = "ddg";
            force = true;
          };
          extensions.packages = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin linkding-extension tridactyl];
        };
        desy = {
          id = 1;
          bookmarks.force = true;
          bookmarks.settings = [
            {
              toolbar = true;
              bookmarks = [
                {
                  url = "https://mail.desy.de/";
                  name = "Mail";
                }
                {
                  url = "https://chat.desy.de/";
                  name = "Chat";
                }
                {
                  url = "https://syncandshare.desy.de/";
                  name = "Sync & Share";
                }
                {
                  url = "https://rt-system.desy.de/";
                  name = "RT";
                }
                {
                  url = "https://www.desy.de/~ucoxwiki/PRkTMFwbOIUGoUd/";
                  name = "Migrationstabelle";
                }
                {
                  url = "https://git.xwikisas.com/xwiki-sas-cpt/desy/-/issues";
                  name = "XWiki Issues";
                }
                {
                  url = "https://it-xwiki-tst.desy.de/xwiki/bin/view/Main/";
                  name = "XWiki Test";
                }
                {
                  url = "https://xwiki.desy.de/xwiki/bin/view/Main/";
                  name = "XWiki Prod";
                }
              ];
            }
          ];
          isDefault = false;
          search = {
            default = "ddg";
            force = true;
          };
          settings = {
            "network.proxy.socks" = "localhost";
            "network.proxy.socks_port" = 2280;
            "network.proxy.type" = 1;
            "network.proxy.socks5_remote_dns" = true;
            "network.proxy.socks_version" = 5;
          };
          extensions.packages = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin tridactyl];
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
  };
}
