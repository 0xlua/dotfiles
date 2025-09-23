{config, ...}: {
  sops.secrets."upvoterss/reddit_user" = {};
  sops.secrets."upvoterss/reddit_client_id" = {};
  sops.secrets."upvoterss/reddit_client_secret" = {};
  sops.templates."upvoterss-env".content = ''
    REDDIT_USER=${config.sops.placeholder."upvoterss/reddit_user"}
    REDDIT_CLIENT_ID=${config.sops.placeholder."upvoterss/reddit_client_id"}
    REDDIT_CLIENT_SECRET=${config.sops.placeholder."upvoterss/reddit_client_secret"}
  '';

  virtualisation.oci-containers.containers = {
    upvoterss = {
      image = "ghcr.io/johnwarne/upvote-rss:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [
        config.sops.templates."upvoterss-env".path
      ];
      volumes = [
        "/home/lua/podman/upvoterss:/app/cache"
      ];
    };
  };
}
