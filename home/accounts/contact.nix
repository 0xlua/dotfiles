{
  config,
  lib,
  ...
}:
lib.mkIf config.home-modules.mail.enable {
  accounts.contact = {
    basePath = ".contacts";
    accounts.lua = let
      userName = "lua@lua.one";
      host = "mail.lua.one";
      passwordCommand = "cat ${config.sops.secrets."stalwart_app_token".path}";
    in {
      remote = {
        type = "carddav";
        url = "https://${host}/.well-known/carddav";
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
      khard = {
        inherit (config.programs.khard) enable;
        type = "discover";
      };
    };
  };
}
