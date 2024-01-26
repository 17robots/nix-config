{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:Nixos/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, ... }: let 
    flags = {
      browser = "firefox";
      terminal = "alacritty";
      windowing = "wayland";
      wm = "sway";
    };
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      system = system;
      overlays = [];
      allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          nixos-hardware.nixosModules.dell-xps-15-9500
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mdray = ./modules/home-manager;
            home-manager.extraSpecialArgs = {inherit inputs; inherit flags;};
          }
          ./modules/nix # config
          ./hosts/laptop/hardware-configuration.nix
        ];
        specialArgs = {inherit inputs; inherit flags;};
      };
    };
  };
}
