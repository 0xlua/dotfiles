{
  osConfig,
  lib,
  ...
}: {
  imports = [../home];
  programs.thunderbird.enable = lib.mkForce osConfig.modules.roles.desktop.gaming.enable; # TODO: osConfig.modules.fewerGuis
  home-modules = {
    inherit (osConfig.modules) user hostname keyMap;
    inherit (osConfig.modules.roles) desktop;
    mail = {inherit (osConfig.modules.roles.desktop) enable;};
    llm = {inherit (osConfig.modules.roles.desktop.gaming) enable;};
    development = {
      enable = true;
      languages = {
        android = {inherit (osConfig.modules.roles.desktop) enable;};
        rust = {inherit (osConfig.modules.roles.desktop) enable;};
        python = {inherit (osConfig.modules.roles.desktop) enable;};
        javascript.enable = with osConfig.modules.roles; desktop.enable || server.caddy.enable; # TODO: || vps.enable
        typesetting = {inherit (osConfig.modules.roles.desktop) enable;};
        data.enable = true;
      };
    };
  };
}
