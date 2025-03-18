{config, ...}: {
  sops.secrets."rauthy/raft" = {};
  sops.secrets."rauthy/api" = {};
  sops.secrets."rauthy/active_key" = {};
  sops.secrets."rauthy/keys" = {};
  sops.secrets."rauthy/smtp/username" = {};
  sops.secrets."rauthy/smtp/password" = {};
  sops.templates."rauthy-cfg" = {
    mode = "0666";
    content = ''
      HQL_SECRET_RAFT=${config.sops.placeholder."rauthy/raft"}
      HQL_SECRET_API=${config.sops.placeholder."rauthy/api"}
      ENC_KEY_ACTIVE=${config.sops.placeholder."rauthy/active_key"}
      ENC_KEYS=${config.sops.placeholder."rauthy/keys"}
      SMTP_USERNAME=${config.sops.placeholder."rauthy/smtp/username"}
      SMTP_PASSWORD="${config.sops.placeholder."rauthy/smtp/password"}"
    '';
  };
  virtualisation.oci-containers.containers.rauthy = {
    image = "ghcr.io/sebadob/rauthy:latest";
    labels = {
      "io.containers.autoupdate" = "registry";
    };
    environment = {
      RP_ID = "auth.lua.one";
      RP_ORIGIN = "https://auth.lua.one:443";
      RP_NAME = "Single Sign-On for lua.one";
      PROXY_MODE = "true";
      TRUSTED_PROXIES = "10.88.0.0/16";
      PUB_URL = "auth.lua.one";
      HQL_NODE_ID = "1";
      HQL_NODES = "1 localhost:8100 localhost:8200\n";
      LISTEN_SCHEME = "http";
      SMTP_URL = "mail.lua.one";
      SMTP_FROM = "Lua Account Service <auth@lua.one>";
    };
    volumes = [
      "/home/lua/podman/rauthy:/app/data"
      "${config.sops.templates."rauthy-cfg".path}:/app/rauthy.cfg"
    ];
  };
}
