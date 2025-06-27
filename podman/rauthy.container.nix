{
  config,
  pkgs,
  ...
}: {
  sops.secrets."rauthy/raft" = {};
  sops.secrets."rauthy/api" = {};
  sops.secrets."rauthy/active_key" = {};
  sops.secrets."rauthy/keys" = {};
  sops.secrets."rauthy/smtp/username" = {};
  sops.secrets."rauthy/smtp/password" = {};
  sops.templates."rauthy-config-toml" = {
    mode = "0666";
    file = (pkgs.formats.toml {}).generate "rauthy-config" {
      cluster = {
        secret_raft = config.sops.placeholder."rauthy/raft";
        secret_api = config.sops.placeholder."rauthy/api";
        node_id = 1;
        nodes = ["1 localhost:8100 localhost:8200"];
      };

      encryption = {
        key_active = config.sops.placeholder."rauthy/active_key";
        keys = [config.sops.placeholder."rauthy/keys"];
      };

      email = {
        smtp_url = "mail.lua.one";
        stmp_from = "Lua Account Service <auth@lua.one>";
        smtp_username = config.sops.placeholder."rauthy/smtp/username";
        smtp_password = config.sops.placeholder."rauthy/smtp/password";
      };

      webauthn = {
        rp_id = "auth.lua.one";
        rp_origin = "https://auth.lua.one:443";
        rp_name = "Single Sign-On for lua.one";
      };

      server = {
        proxy_mode = true;
        trusted_proxies = ["10.88.0.0/16"];
        pub_url = "auth.lua.one";
        scheme = "http";
      };
    };
  };
  virtualisation.oci-containers.containers.rauthy = {
    image = "ghcr.io/sebadob/rauthy:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    volumes = [
      "/home/lua/podman/rauthy:/app/data"
      "${config.sops.templates."rauthy-config-toml".path}:/app/config.toml"
    ];
  };
}
