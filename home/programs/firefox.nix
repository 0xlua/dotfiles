{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];

  xdg.configFile."tridactyl/tridactylrc".source = ../../files/tridactylrc;

  programs.firefox = let
    ext = inputs.firefox-addons.packages.x86_64-linux;
    extensions = with ext; [bitwarden ublock-origin linkding-extension tridactyl libredirect];
  in {
    inherit (config.home-modules.desktop) enable;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      DisplayMenuBar = "never";
      SearchBar = "unified";
      TranslateEnabled = false;
      PictureInPicture.Enabled = false;
      "3rdparty".Extensions = {
        ${ext.ublock-origin.addonId}.adminSettings = {
          userSettings = rec {
            advancedUserEnabled = true;
            externalLists = lib.concatLines importedLists;
            firewallPaneMinimized = false;
            importedLists = ["https://raw.githubusercontent.com/DandelionSprout/adfilt/master/LegitimateURLShortener.txt"];
            popupPanelSections = 31;
          };
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
          dynamicFilteringString = lib.concatLines [
            "* * 3p-script block"
            "* * 3p-frame block"
            "letterboxd.com ltrbxd.com * noop"
            "github.com githubassets.com * noop"
          ];
          hostnameSwitchesString = lib.concatLines [
            "no-large-media: behind-the-scene false"
            "no-csp-reports: * true"
            "no-scripting: マリウス.com true"
          ];
        };
      };
    };
    globalExtensions = extensions;
    profiles.default = {
      isDefault = true;
      settings = let
        navBar = {
          "placements" = {
            "widget-overflow-fixed-list" = [];
            "unified-extensions-area" = ["gdpr_cavi_au_dk-browser-action"]; # TODO: dynamically create this from extension.addonId and replacing [{}@.] with "_"
            "nav-bar" = ["sidebar-button" "back-button" "forward-button" "stop-reload-button" "home-button" "urlbar-container" "downloads-button" "ublock0_raymondhill_net-browser-action" "7esoorv3_alefvanoon_anonaddy_me-browser-action" "_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action" "_61a05c39-ad45-4086-946f-32adb0a40a9d_-browser-action" "_testpilot-containers-browser-action" "unified-extensions-button"];
          };
          "currentVersion" = 24;
        };
      in {
        "widget.gtk.libadwaita-colors.enabled" = false; # allow native styling
        "layout.css.prefers-color-scheme.content-override" = 0; # dark mode
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "hide-sidebar";
        "browser.toolbars.bookmarks.visibility" = "never";
        "browser.startup.page" = 0;
        "browser.uiCustomization.state" = navBar;
        "browser.newtabpage.pinned" = [];
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        # re-enable native messaging (https://codeberg.org/celenity/Phoenix/commit/bb82bd987d8a5347d1d7213ffb8820298d51a52f)
        "webextensions.native-messaging.max-input-message-bytes" = 1048576;
        "webextensions.native-messaging.max-output-message-bytes" = 2147483647;
        "network.protocol-handler.expose.bitwarden" = false;
        "network.protocol-handler.external.bitwarden" = true;
      };
      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
