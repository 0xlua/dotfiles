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
        dependsOn = ["broker"]; # TODO: smb mount @ ~/media & ~/consume; bind to broker
        labels = {"io.containers.autoupdate" = "registry";};
        environment = {
          PAPERLESS_TIME_ZONE = "Europe/Berlin";
          USERMAP_UID = "0";
          USERMAP_GID = "0";
          PAPERLESS_REDIS = "redis://localost:6379";
          PAPERLESS_CONSUMER_POLLING = "10";
        };
        extraOptions = ["--security-opt label=disable"];
        ports = ["4000:8000"];
        volumes = [
          "/home/lua/podman/paperless:/usr/src/paperless/data"
          "/home/lua/scanner:/usr/src/paperless/consume"
          "/home/lua/media/documents:/usr/src/paperless/media"
        ];
      };

      broker = {
        image = "docker.io/library/redis:7";
        labels = {"io.containers.autoupdate" = "registry";};
        extraOptions = ["--security-opt label=disable"];
        volumes = ["/home/lua/podman/paperless_broker:/data"];
        networks = ["container:podman-paperless"];
      };
    };
  };
}
