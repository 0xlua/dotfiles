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
      example = [
        {
          source = "//example.com/share";
          target = "/mnt/nas";
          specialOptions = ["noauto"];
        }
      ];
      description = "List of Samba Shares to mount";
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
          owner = config.modules.user.name;
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
          options = let
            user = config.users.users.${config.modules.user.name};
            group = config.users.groups.${user.group};
          in
            [
              "x-systemd.automount"
              "credentials=${config.sops.templates."smb-secrets".path}"
              "uid=${user.uid}"
              "gid=${group.gid}"
            ]
            ++ mount.specialOptions;
        };
      })
      cfg.mounts);
  };
}
