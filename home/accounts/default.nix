{
  inputs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules.mail;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./mail.nix
    ./contact.nix
    ./calendar.nix
  ];
  options.home-modules.mail.enable = lib.mkEnableOption "mail";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.home-modules.desktop.enable;
        message = "Set home-modules.desktop.enable = true, if you want to enable mail";
      }
    ];
    sops.secrets = {
      "stalwart_app_token".mode = "0440";
      "mailbox_app_token".mode = "0440";
    };

    services.pimsync.enable = true;

    programs.pimsync.enable = true;

    programs.khal = {
      enable = true;
      settings.default.highlight_event_days = true;
    };

    programs.khard.enable = true;
  };
}
