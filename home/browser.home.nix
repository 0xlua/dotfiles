{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    imports = [
      # TODO: compare my policies with phoenix
      # inputs.phoenix.nixosModules.default
    ];
    stylix.targets.firefox.profileNames = ["default" "desy"];
    xdg.configFile."tridactyl/tridactylrc".source = ../tridactylrc;
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
      nativeMessagingHosts = [pkgs.tridactyl-native];
      policies = {
        Cookies.Behavior = "reject-foreign";
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
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
        DisableFormHistory = true;
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
        TranslateEnabled = false;
        PictureInPicture.Enabled = false;
        Preferences = {
          "browser.contentblocking.category" = "strict";
          "browser.ml.chat.enabled" = false;
          "sidebar.verticalTabs" = true;
          "general.autoScroll" = true;
          "extensions.autoDisableScopes" = 0;
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
          settings."uBlock0@raymondhill.net".settings = {
            selectedFilterLists = [
              "user-filters"
              "ublock-filters"
              "ublock-badware"
              "ublock-privacy"
              "ublock-quick-fixes"
              "ublock-unbreak"
              "easylist"
              "easyprivacy"
              "adguard-spyware-url"
              "urlhaus-1"
              "plowe-0"
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"
            ];
          };
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
          extensions.packages = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin multi-account-containers tridactyl];
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
