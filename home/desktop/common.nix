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

    sops.secrets.luks_thumbdrive.mode = "0440";

    services.udiskie = {
      enable = true;
      settings = {
        # see https://github.com/nix-community/home-manager/issues/632
        program_options = let
          foot = lib.getExe config.programs.foot.package;
        in {
          file_manager = "${foot} ${lib.getExe config.programs.yazi.package}";
          terminal = "${foot} -D";
        };
        device_config = [
          {
            id_uuid = "20f971c7-bed2-49a2-8810-56c2e02ff087";
            keyfile = config.sops.secrets.luks_thumbdrive.path;
          }
        ];
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
