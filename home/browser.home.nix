{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager.users.lua = {pkgs, ...}: {
    imports = [
      inputs.arkenfox.hmModules.arkenfox
    ];
    stylix.targets.firefox.profileNames = ["default" "desy"];
    xdg.configFile."tridactyl/tridactylrc".source = ../tridactylrc;
    programs.firefox = {
      enable = true;
      package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
      arkenfox = {
        enable = true;
        version = "133.0";
      };
      nativeMessagingHosts = [pkgs.tridactyl-native];
      policies = {
        Cookies.Behavior = "reject-foreign";
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
          bookmarks.force = true;
          bookmarks.settings = [
            {
              toolbar = true;
              bookmarks = [
                {
                  url = "http://ganymede:3000/";
                  name = "";
                }
                {
                  url = "https://b.lua.one/bookmarks";
                  name = "";
                }
                {
                  url = "https://rss.lua.one/unread";
                  name = "";
                }
                {
                  url = "https://reddit.lua.one/";
                  name = "";
                }
                {
                  url = "https://letterboxd.com/";
                  name = "";
                }
                {
                  url = "https://account.proton.me/";
                  name = "";
                }
                {
                  url = "https://github.com/";
                  name = "";
                }
                {
                  url = "https://codeberg.org/";
                  name = "";
                }
                {
                  url = "https://web.whatsapp.com/";
                  name = "";
                }
                {
                  url = "https://www.hvv.de/";
                  name = "";
                }
                {
                  url = "https://www.openstreetmap.org/";
                  name = "";
                }
                {
                  url = "https://www.inwx.de/";
                  name = "";
                }
                {
                  url = "https://console.hetzner.cloud/";
                  name = "";
                }
                {
                  url = "https://www.mydealz.de/";
                  name = "";
                }
                {
                  url = "https://geizhals.de/";
                  name = "";
                }
                {
                  url = "http://store.steampowered.com/";
                  name = "";
                }
                {
                  url = "https://www.comdirect.de/";
                  name = "";
                }
                {
                  url = "https://savoy.premiumkino.de/";
                  name = "";
                }
                {
                  url = "https://www.kino-zeit.de/";
                  name = "";
                }
                {
                  url = "https://kachelmannwetter.com/de/wetter/2911298-hamburg";
                  name = "";
                }
                {
                  url = "https://lichess.org/";
                  name = "";
                }
                {
                  url = "https://grondilu.github.io/memchess/";
                  name = "";
                }
                {
                  url = "https://listudy.org/en";
                  name = "";
                }
              ];
            }
          ];
          search = {
            default = "ddg";
            force = true;
          };
          extensions.packages = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin linkding-extension tridactyl];
          arkenfox = {
            enable = true;
            "0000".enable = true;
            "0100".enable = true;
            "0200".enable = true;
            "0300".enable = true;
            # TODO: enable more sections, but read them beforehand
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
