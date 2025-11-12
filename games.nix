{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager.users.lua = {pkgs, ...}: {
    home.packages = with pkgs; [
      lact
      mumble
      teamspeak6-client
      # bottles
      # mangohud
    ];
    programs.discord = {
      enable = true;
      package = pkgs.discord-ptb;
    };
  };

  programs.corectrl = {
    enable = true;
  };

  hardware.amdgpu.overdrive.enable = true;

  programs.gamemode = {
    enable = true;
    settings.general.inhibit_screensaver = 0;
  };

  users.users.lua.extraGroups = ["gamemode"];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    # extest.enable = true; # steam input wayland compat
    gamescopeSession = {
      enable = true;
      args = [
        "--adaptive-sync"
        "--hdr-enabled"
        # "--mangoapp"
        "--rt"
      ];
    };
    extraCompatPackages = with pkgs; [proton-ge-bin];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
