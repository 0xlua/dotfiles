{config, ...}: {
  sops = {
    secrets = {
      "nas/username_server" = {};
      "nas/domain" = {};
      "nas/password" = {};
    };
    templates = {
      "smb-secrets-server" = {
        owner = "lua";
        content = ''
          username=${config.sops.placeholder."nas/username_server"}
          domain=${config.sops.placeholder."nas/domain"}
          password=${config.sops.placeholder."nas/password"}
        '';
      };
    };
  };

  fileSystems."/home/lua/media" = {
    device = "//io.internal/media";
    fsType = "cifs";
    options = let
      automount_opts = "nobrl,x-systemd.automount,x-systemd.requires=network-online.target";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secret-server".path},uid=1000,gid=100"];
  };

  fileSystems."/home/lua/scanner" = {
    device = "//io.internal/scanner";
    fsType = "cifs";
    options = let
      automount_opts = "nobrl,x-systemd.automount,x-systemd.requires=network-online.target";
    in ["${automount_opts},credentials=${config.sops.templates."smb-secret-server".path},uid=1000,gid=100"];
  };
}
