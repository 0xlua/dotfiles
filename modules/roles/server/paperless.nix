{
  config,
  lib,
  ...
}: let
  cfg = config.server.paperless;
in {
  options.server.paperless.enable = lib.mkEnableOption "paperless-ngx";

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      paperless = {
        image = "ghcr.io/paperless-ngx/paperless-ngx:latest";
        autoStart = true;
        dependsOn = ["redis"];
        labels."io.containers.autoupdate" = "registry";
        environment = {
          PAPERLESS_TIME_ZONE = "Europe/Berlin";
          USERMAP_UID = "1000";
          USERMAP_GID = "100";
          PAPERLESS_REDIS = "redis://redis:6379";
          PAPERLESS_CONSUMER_POLLING = "10";
        };
        ports = ["4000:8000"];
        volumes = [
          "/home/lua/podman/paperless:/usr/src/paperless/data:Z"
          "/home/lua/scanner:/usr/src/paperless/consume:z"
          "/home/lua/media/documents:/usr/src/paperless/media:z"
        ];
      };

      redis = {
        image = "docker.io/library/redis:7";
        labels."io.containers.autoupdate" = "registry";
        volumes = ["/home/lua/podman/redis:/data:Z"];
      };
    };
  };
}
