{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.targets.firefox.profileNames = ["default"];

  xdg = {
    configFile."tridactyl/tridactylrc".source = ../../files/tridactylrc;
    mimeApps = {
      associations.added = {"application/pdf" = ["firefox.desktop"];};
      defaultApplications."application/json" = ["firefox.desktop"];
    };
  };

  programs.firefox = {
    inherit (config.home-modules.desktop) enable;
    package = pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {pipewireSupport = true;}) {};
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    nativeMessagingHosts = [pkgs.tridactyl-native];
    policies = {
      DisplayMenuBar = "never";
      SearchBar = "unified";
      TranslateEnabled = false;
      PictureInPicture.Enabled = false;
      Preferences = {
        "widget.gtk.libadwaita-colors.enabled" = false; # allow native styling
        "layout.css.prefers-color-scheme.content-override" = 0; # dark mode
        "sidebar.verticalTabs" = true;
        "sidebar.visibility" = "hide-sidebar";
        "browser.newtabpage.pinned" = [];
        "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
        # re-enable native messaging (https://codeberg.org/celenity/Phoenix/commit/bb82bd987d8a5347d1d7213ffb8820298d51a52f)
        "webextensions.native-messaging.max-input-message-bytes" = 1048576;
        "webextensions.native-messaging.max-output-message-bytes" = 999999999;
      };
    };
    globalExtensions = with inputs.firefox-addons.packages.x86_64-linux; [bitwarden ublock-origin linkding-extension tridactyl];
    profiles.default = {
      isDefault = true;
      #extensions.settings."uBlock0@raymondhill.net" = {};
      search = {
        default = "ddg";
        force = true;
      };
    };
  };
}
