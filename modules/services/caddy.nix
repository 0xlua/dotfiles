{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.server.caddy;
in {
  options.server.caddy.enable = lib.mkEnableOption "caddy";

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "caddy/inwx_username" = {};
        "caddy/inwx_password" = {};
        "caddy/inwx_mfattoken" = {};
        "caddy/upvoterss_password" = {};
      };
      templates."caddy_env" = {
        owner = "lua";
        content = ''
          INWX_USERNAME=${config.sops.placeholder."caddy/inwx_username"}
          INWX_PASSWORD=${config.sops.placeholder."caddy/inwx_password"}
          INWX_MFATOKEN=${config.sops.placeholder."caddy/inwx_mfatoken"}
          UPVOTERSS_PASSWORD=${config.sops.placeholder."caddy/upvoterss_password"}
        '';
      };
    };
    programs.rust-motd.settings.service_status.caddy = config.virtualisation.oci-containers.containers.caddy.serviceName;
    virtualisation.oci-containers.containers.caddy = let
      # TODO: flake input?
      tag = "2";
      caddyImage = pkgs.dockerTools.pullImage {
        imageName = "caddy";
        imageDigest = "sha256:5f5c8640aae01df9654968d946d8f1a56c497f1dd5c5cda4cf95ab7c14d58648"; #caddy:2-alpine
        finalImageTag = "${tag}-alpine";
        hash = "sha256-6mnjC1vUPJMs/qjwsY4bMQBIUopUvigsZPQUd0GllvM=";
      };
      caddy = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/inwx@v0.4.1"
          # "github.com/mholt/caddy-ratelimit"
          "pkg.jsn.cam/caddy-defender@v0.10.1"
        ];
        hash = "sha256-pvj3aLQrKWLQnqCK+sd7EHOM3NMW5oxFMuBBWzuYd6I=";
      };
      imageFile = pkgs.dockerTools.buildImage {
        name = "caddy";
        tag = "${tag}-alpine";
        fromImage = caddyImage;
        fromImageName = "caddy";
        fromImageTag = "${tag}-alpine";
        copyToRoot = "${caddy}/bin";
        extraCommands = ''
          mkdir -p ./usr/bin
          mv ./caddy ./usr/bin/
        '';
        config = {
          Workdir = "/srv";
          Cmd = ["caddy" "run" "--config" "/etc/caddy/Caddyfile" "--adapter" "caddyfile"];
        };
      };
    in {
      # image = "docker.io/caddy:2-alpine";
      image = "caddy:2-alpine";
      inherit imageFile;
      user = "1000:100";
      capabilities = {
        ALL = false;
        NET_BIND_SERVICE = true;
        NET_ADMIN = true; #optional: improves HTTP/3 performance
      };
      extraOptions = [
        "--read-only"
        "--security-opt=no-new-privileges"
      ];
      autoStart = true;
      environmentFils = [config.sops.templates."caddy_env".path];
      volumes = [
        "${../../files/caddy}:/etc/caddy:ro"
        "/home/lua/podman/static:/srv"
        "/home/lua/podman/caddy:/data"
      ];
      ports = ["80:80/tcp" "443:443/tcp" "443:443/udp"];
    };
  };
}
