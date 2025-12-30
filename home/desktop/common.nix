{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.home-modules.desktop;
in {
  options.home-modules.desktop = {
    enable = lib.mkEnableOption "a graphic desktop envrionment";
    compositor = lib.mkOption {
      type = with lib.types; nullOr (enum ["cosmic" "niri"]);
      default = null;
      example = "cosmic";
      description = "What desktop envrionment to use";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      libnotify
      xwayland-satellite
    ];

    services.syncthing = {
      enable = true;
      settings = {
        folders = {
          "default" = {
            path = "${config.home.homeDirectory}/Sync";
          };
          "njho7-shvne" = {
            path = "${config.home.homeDirectory}/notes";
          };
        };
      };
    };

    services.wpaperd.enable = true;

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    xdg.mimeApps.enable = true;
  };
}
