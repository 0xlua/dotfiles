{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.samba;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.modules.samba = {
    enable = lib.mkEnableOption "samba mounts";
    mounts = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            source = lib.mkOption {type = str;};
            target = lib.mkOption {type = str;};
            specialOptions = lib.mkOption {type = listOf str;};
          };
        });
      default = [];
      example = "cosmic";
      description = "What desktop envrionment to use";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      secrets = {
        "nas/username" = {};
        "nas/domain" = {};
        "nas/password" = {};
      };
      templates = {
        "smb-secrets" = {
          owner = "lua";
          content = ''
            username=${config.sops.placeholder."nas/username"}
            domain=${config.sops.placeholder."nas/domain"}
            password=${config.sops.placeholder."nas/password"}
          '';
        };
      };
    };

    environment.systemPackages = [pkgs.cifs-utils];

    fileSystems = lib.listToAttrs (lib.map (mount: {
        name = mount.target;
        value = {
          device = mount.source;
          fsType = "cifs";
          options =
            [
              "x-systemd.automount"
              "credentials=${config.sops.templates."smb-secrets".path}"
              "uid=1000"
              "gid=100"
            ]
            ++ mount.specialOptions;
        };
      })
      cfg.mounts);
  };
}
