{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.server.rustypaste;
in {
  options.server.rustypaste.enable = lib.mkEnableOption "rustypaste";

  config = lib.mkIf cfg.enable {
    sops.secrets.rustypasteToken = {
      mode = "0440";
      owner = config.users.users.lua.name;
      group = config.users.users.lua.group;
    };

    programs.rust-motd.settings.service_status.rustypaste = config.virtualisation.oci-containers.containers.rustypaste.serviceName;
    virtualisation.oci-containers.containers.rustypaste = let
      settingsFormat = pkgs.formats.toml {};
      settingsFile = settingsFormat.generate "rustypaste" {
        config.refresh_rate = "1s";

        server = {
          address = "share.lua.one";
          max_content_length = "850MB";
          upload_path = "./upload";
          timeout = "30s";
          expose_version = true;
          expose_list = true;
          hardening = true;
        };

        landing_page = {
          file = "/app/index.html";
          content_type = "text/html; charset=utf-8";
        };

        paste = {
          random_url = {
            type = "alphanumeric";
            length = 8;
          };
          default_extension = "txt";
          mime_override = [
            {
              mime = "image/jpeg";
              regex = "^.*\\.jpg$";
            }
            {
              mime = "image/png";
              regex = "^.*\\.png$";
            }
            {
              mime = "image/svg+xml";
              regex = "^.*\\.svg$";
            }
            {
              mime = "video/webm";
              regex = "^.*\\.webm$";
            }
            {
              mime = "video/x-matroska";
              regex = "^.*\\.mkv$";
            }
            {
              mime = "application/octet-stream";
              regex = "^.*\\.bin$";
            }
            {
              mime = "text/plain";
              regex = "^.*\\.(log|txt|diff)$";
            }
          ];
          text_mime_overrides = [
            "application/toml"
            "application/yaml"
            "application/x-yaml"
          ];
          mime_blacklist = [
            "application/x-dosexec"
            "application/java-archive"
            "application/java-vm"
          ];
          duplicate_files = true;
          delete_expired_files = {
            enabled = true;
            interval = "1h";
          };
        };
      };
    in {
      image = "docker.io/orhunp/rustypaste:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      user = "1000:100";
      environment = {
        AUTH_TOKENS_FILE = "/run/secrets/tokens";
        DELETE_TOKENS_FILE = "/run/secrets/tokens";
      };
      volumes = [
        "/home/lua/podman/rustypaste:/app/upload"
        "${inputs.rustypaste-ui}:/app/index.html"
        "${settingsFile}:/app/config.toml"
        "${config.sops.secrets.rustypasteToken.path}:/run/secrets/tokens"
      ];
    };
  };
}
