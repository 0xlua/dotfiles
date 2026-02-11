{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # TODO: changes to the build script broke the phoenix flake
    phoenix.url = "git+https://codeberg.org/celenity/Phoenix?rev=6ec3afbd6cc80bfbfaf7bb9e389940953c8f99d5";
    phoenix.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    eilmeldung.url = "github:christo-auer/eilmeldung";
    # TODO: newer sops-nix uses IPv6, possibly because of go 1.25
    sops-nix.url = "github:Mic92/sops-nix?rev=17eea6f3816ba6568b8c81db8a4e6ca438b30b7c";
  };

  outputs = inputs: {
    nixosConfigurations = {
      homeConfigurations."lua" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/lua
        ];
      };
      europa = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
          inputs.phoenix.nixosModules.default
          ./modules
          ./hosts/europa
        ];
      };
      callisto = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          inputs.phoenix.nixosModules.default
          ./modules
          ./hosts/callisto
        ];
      };
      galileo = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./modules
          ./hosts/galileo
        ];
      };
      ganymede = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./modules
          ./hosts/ganymede
        ];
      };
    };
  };
}
