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
    preferLessGuis = lib.mkEnableOption "less GUI Apps";
    compositor = lib.mkOption {
      type = lib.types.enum ["none" "cosmic" "niri"];
      default = "none";
      example = "cosmic";
      description = "What desktop envrionment to use. `none` installs no compositor and only relies on the tty";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      [
        wl-clipboard
        libnotify
        xwayland-satellite
      ]
      ++ lib.lists.optional (!cfg.preferLessGuis) yubioath-flutter;

    services.udiskie = {
      enable = true;
      settings = {
        # see https://github.com/nix-community/home-manager/issues/632
        program_options = {
          file_manager = lib.getExe config.programs.yazi.package;
          terminal = lib.getExe config.programs.foot.package;
        };
      };
    };

    services.wpaperd.enable = true;

    dconf.settings."org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplicationPackages = [
        config.programs.zathura.package
        config.programs.firefox.package
        config.programs.yazi.package
        config.programs.helix.package
        config.programs.mpv.package
        config.programs.imv.package
      ];
      defaultApplications."x-scheme-handler/mpv" = ["mpv.desktop"];
    };
  };
}
