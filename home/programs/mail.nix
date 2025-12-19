{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
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
    thunderbird.enable = true;
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
}
