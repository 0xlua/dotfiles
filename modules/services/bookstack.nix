{
  config,
  lib,
  ...
}: let
  cfg = config.server.bookstack;
in {
  options.server.bookstack.enable = lib.mkEnableOption "BookStack";

  config = lib.mkIf cfg.enable {
    sops = {
      secrets."bookstack/app_key" = {};
      secrets."bookstack/oidc_client_id" = {};
      secrets."bookstack/oidc_client_secret" = {};
      secrets."bookstack/db_name" = {};
      secrets."bookstack/db_user" = {};
      secrets."bookstack/db_password" = {};
      templates."bookstack.env".content = ''
        APP_KEY=${config.sops.placeholder."bookstack/app_key"}
        OIDC_CLIENT_ID=${config.sops.placeholder."bookstack/oidc_client_id"}
        OIDC_CLIENT_SECRET=${config.sops.placeholder."bookstack/oidc_client_secret"}
        DB_DATABASE=${config.sops.placeholder."bookstack/db_name"}
        DB_USERNAME=${config.sops.placeholder."bookstack/db_user"}
        DB_PASSWORD=${config.sops.placeholder."bookstack/db_password"}
      '';
      templates."bookstack_db.env".content = ''
        MYSQL_DATABASE=${config.sops.placeholder."bookstack/db_name"}
        MYSQL_USER=${config.sops.placeholder."bookstack/db_user"}
        MYSQL_PASSWORD=${config.sops.placeholder."bookstack/db_password"}
      '';
    };
    virtualisation.oci-containers.containers = {
      bookstack = {
        image = "lscr.io/linuxserver/bookstack:latest";
        autoStart = true;
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        environmentFiles = [
          config.sops.templates."bookstack.env".path
        ];
        environment = {
          PUID = "1000";
          PGID = "100";
          APP_DISPLAY_TIMEZONE = "Europe/Berlin";
          APP_URL = "https://wiki.lua.one";
          STORAGE_TYPE = "local_secure";
          APP_PROXIES = "10.88.0.22"; # caddy ip

          # DB Settings
          DB_HOST = "bookstack-db";
          DB_PORT = "3306";

          # OIDC Settings
          AUTH_METHOD = "oidc";
          AUTH_AUTO_INITIATE = "false";
          OIDC_ISSUER = "https://id.lua.one";
          OIDC_END_SESSION_ENDPOINT = "true";
          OIDC_ISSUER_DISCOVER = "true";
          OIDC_FETCH_AVATAR = "true";
          OIDC_USER_TO_GROUPS = "true";
          OIDC_GROUPS_CLAIM = "groups";
          OIDC_ADDITIONAL_SCOPES = "groups";
          OIDC_REMOVE_FROM_GROUPS = "true";
        };
        volumes = [
          "/home/lua/podman/bookstack:/config"
        ];
      };
      bookstack-db = {
        image = "lscr.io/linuxserver/mariadb:11.4.8";
        autoStart = true;
        labels = {
          "io.containers.autoupdate" = "registry";
        };
        environmentFiles = [
          config.sops.templates."bookstack_db.env".path
        ];
        environment = {
          PUID = "1000";
          PGID = "100";
        };
        volumes = [
          "/home/lua/podman/bookstack-db:/config"
        ];
      };
    };
  };
}
