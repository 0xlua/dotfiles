{
  config,
  lib,
  ...
}: let
  cfg = config.server.upvoterss;
in {
  options.server.upvoterss.enable = lib.mkEnableOption "upvote-rss";

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "upvoterss/reddit_user" = {};
        "upvoterss/reddit_client_id" = {};
        "upvoterss/reddit_client_secret" = {};
      };
      templates."upvoterss-env".content = ''
        REDDIT_USER=${config.sops.placeholder."upvoterss/reddit_user"}
        REDDIT_CLIENT_ID=${config.sops.placeholder."upvoterss/reddit_client_id"}
        REDDIT_CLIENT_SECRET=${config.sops.placeholder."upvoterss/reddit_client_secret"}
      '';
    };

    programs.rust-motd.settings.service_status.upvoterss = config.virtualisation.oci-containers.containers.upvoterss.serviceName;
    virtualisation.oci-containers.containers.upvoterss = {
      image = "ghcr.io/johnwarne/upvote-rss:latest";
      autoStart = true;
      labels."io.containers.autoupdate" = "registry";
      environmentFiles = [
        config.sops.templates."upvoterss-env".path
      ];
      volumes = [
        "/home/lua/podman/upvoterss:/app/cache"
      ];
    };
  };
}
