{inputs, ...}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;

  home-manager.users.lua = {pkgs, ...}: {
    home.packages = with pkgs; [
      discord-ptb
    ];
  };

  programs.steam = {
    enable = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
