{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.roles.server.multiscrobbler;
  msConfig = (pkgs.formats.json {}).generate "msConfig" {
    # baseURL = "https://scrobble.lua.one";
    sources = [
      {
        type = "endpointlz";
        id = "endpoint_source";
        enable = true;
        name = "(ListenBrainz) Endpoint Source";
        data.token = "[[LISTENBRAINZ_SOURCE_TOKEN]]";
      }
    ];
    clients = [
      {
        type = "koito";
        id = "koito_client";
        name = "Koito Client";
        configureAs = "client";
        data = {
          url = "http://koito:4110";
          token = "[[KOITO_API_KEY]]";
          username = "lua";
        };
      }
    ];
  };
in {
  options.modules.roles.server.multiscrobbler.enable = lib.mkEnableOption "Multi-Scrobbler";

  config = lib.mkIf cfg.enable {
    programs.rust-motd.settings.service_status.multiscrobbler = config.virtualisation.oci-containers.containers.multiscrobbler.serviceName;

    sops = {
      secrets = {
        "multi_scrobbler/koito_api_key".mode = "0440";
        "multi_scrobbler/listenbrainz_api_key".mode = "0440";
        "multi_scrobbler/listenbrainz_source_token".mode = "0440";
        "multi_scrobbler/admin_pw".mode = "0440";
      };
      templates."msEnv".content = ''
        KOITO_API_KEY=${config.sops.placeholder."multi_scrobbler/koito_api_key"}
        LISTENBRAINZ_API_KEY=${config.sops.placeholder."multi_scrobbler/listenbrainz_api_key"}
        LISTENBRAINZ_SOURCE_TOKEN=${config.sops.placeholder."multi_scrobbler/listenbrainz_source_token"}
        ADMIN_SETUP_PW=${config.sops.placeholder."multi_scrobbler/admin_pw"}
      '';
    };

    virtualisation.oci-containers.containers.multiscrobbler = {
      image = "ghcr.io/foxxmd/multi-scrobbler:latest";
      autoStart = true;
      user = "1000:100";
      capabilities.ALL = false;
      extraOptions = [
        "--health-cmd=[\"curl\", \"-fsS\", \"http://localhost:4110/api/health\"]"
        "--health-interval=30s"
        "--health-timeout=5s"
        # "--read-only"
        # "--tmpfs=/run:exec"
        # "--tmpfs=/tmp:noexec"
        # "--security-opt=no-new-privileges"
      ];
      environmentFiles = [config.sops.templates."msEnv".path];
      environment = {
        DATA_DIR = "/msData";
        TZ = "Europe/Berlin";
      };
      ports = ["9078:9078/tcp"];
      labels."io.containers.autoupdate" = "registry";
      volumes = ["${msConfig}:/config/config.json" "/home/lua/podman/multiscrobbler:/msData"];
    };
  };
}
