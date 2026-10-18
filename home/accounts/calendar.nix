{
  config,
  lib,
  ...
}:
lib.mkIf config.home-modules.mail {
  accounts.calendar = {
    basePath = ".calendars";
    accounts.lua = let
      userName = "lua@lua.one";
      host = "mail.lua.one";
      passwordCommand = "cat ${config.sops.secrets."stalwart_app_token".path}";
    in {
      remote = {
        type = "caldav";
        url = "https://${host}/.well-known/caldav";
        inherit userName;
        passwordCommand = lib.strings.splitString " " passwordCommand;
      };
      pimsync = {
        inherit (config.programs.pimsync) enable;
        extraRemoteStorageDirectives = [
          {
            name = "collection_id_segment";
            params = ["second-last"];
          }
        ];
        extraPairDirectives = [
          {
            name = "collections";
            params = ["all"];
          }
        ];
      };
      khal = {
        inherit (config.programs.khal) enable;
        # TODO: map accounts.email.accounts.*.address
        addresses = [userName];
        type = "discover";
        color = "dark green";
      };
    };
  };
}
