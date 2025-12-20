{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.home-modules;
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  options.home-modules.mail.enable = lib.mkEnableOption "mail";

  config = lib.mkIf cfg.mail.enable {
    programs.aerc = {
      enable = true;
      extraConfig.general.unsafe-accounts-conf = true;
    };
    programs.thunderbird = {
      enable = lib.mkIf cfg.desktop != null;
      package = pkgs.thunderbird-latest;
      profiles.lua = {
        isDefault = true;
        settings = {
          "calendar.week.start" = 1;
        };
      };
    };
    sops.secrets."mailAppPw".mode = "0440";
    accounts.calendar.accounts.lua.remote = {
      type = "caldav";
      url = "https://mail.lua.one/.well-known/caldav";
      userName = "moin@lua.one";
      passwordCommand = "cat ${config.sops.secrets."mailAppPw".path}";
    };
    accounts.email.accounts.lua = {
      address = "moin@lua.one";
      userName = "moin@lua.one";
      primary = true;
      realName = "Lukas Jordan";
      imap = {
        host = "mail.lua.one";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.lua.one";
        port = 465;
        tls.enable = true;
      };
      passwordCommand = "cat ${config.sops.secrets."mailAppPw".path}";
      thunderbird.enable = lib.mkIf cfg.desktop != null;
      aerc = {
        enable = true;
        imapAuth = "oauthbearer";
        imapOauth2Params = {
          client_id = "mail";
          client_secret = "TODO";
          scope = "openid profile email";
          token_endpoint = "https://auth.lua.one/auth/v1/oidc/token";
        };
        smtpAuth = "oauthbearer";
        smtpOauth2Params = {
          client_id = "mail";
          client_secret = "TODO";
          scope = "openid profile email";
          token_endpoint = "https://auth.lua.one/auth/v1/oidc/token";
        };
      };
    };
  };
}
