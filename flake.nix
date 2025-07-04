{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    hl.url = "github:pamburus/hl";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixpkgs.follows = "cosmic/nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = inputs: {
    nixosConfigurations = {
      europa = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          inputs.lanzaboote.nixosModules.lanzaboote
          ./hardware/europa.nix
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
          ./hosts/europa.nix
          ./base.nix
          ./graphical.nix
          ./niri.nix
          ./home/base.home.nix
          ./home/graphical.home.nix
          ./home/niri.home.nix
          ./home/dev.home.nix
          ./home/browser.home.nix
          ./home/neovim.home.nix
        ];
      };
      callisto = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware/callisto.nix
          ./hosts/callisto.nix
          ./base.nix
          ./graphical.nix
          ./cosmic.nix
          ./games.nix
          ./home/base.home.nix
          ./home/graphical.home.nix
          ./home/mail.home.nix
          ./home/dev.home.nix
          ./home/browser.home.nix
          ./home/neovim.home.nix
        ];
      };
      galileo = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hardware/galileo.nix
          ./hosts/galileo.nix
          ./base.nix
          ./home/base.home.nix
          ./home/server.home.nix
          ./home/dev.home.nix
          ./podman
        ];
      };
    };
  };
}
