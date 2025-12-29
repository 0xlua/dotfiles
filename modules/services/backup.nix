{
  config,
  lib,
  ...
}: let
  cfg = config.server.podman-backup;
in {
  options.server.podman-backup.enable = lib.mkEnableOption "docker/podman volume backup";

  config = lib.mkIf cfg.enable {
    sops.secrets.backupSshPassword = {};
    sops.templates."backup-env".content = ''
      SSH_PASSWORD=${config.sops.placeholder.backupSshPassword};
    '';

    virtualisation.oci-containers.containers.backup = {
      image = "docker.io/offen/docker-volume-backup:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates."backup-env".path
      ];
      environment = {
        SSH_HOST_NAME = "u413359.your-storagebox.de";
        SSH_REMOTE_PATH = "galileo";
        SSH_USER = "u413359";
        BACKUP_RETENTION_DAYS = "7";
      };
      volumes = [
        "/home/lua/podman:/backup:ro"
      ];
    };
  };
}
