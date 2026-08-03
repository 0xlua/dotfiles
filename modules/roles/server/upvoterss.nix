{
  config,
  lib,
  ...
}: let
  cfg = config.modules.roles.server.upvoterss;
in {
  options.modules.roles.server.upvoterss.enable = lib.mkEnableOption "upvote-rss";

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
      capabilities = {
        # That's a lot of caps...
        ALL = false;
        CHOWN = true;
        SETGID = true;
        SETUID = true;
        FOWNER = true;
        NET_BIND_SERVICE = true;
      };
      extraOptions = [
        "--health-cmd=[\"curl\", \"-f\", \"http://localhost:80\"]"
        "--health-interval=30s"
        "--health-timeout=10s"
        # "--read-only"
        # "--security-opt=no-new-privileges"
      ];
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
