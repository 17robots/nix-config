{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:Nixos/nixos-hardware/master";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    anyrun.url  = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
  };

  outputs = inputs@{ anyrun, nixpkgs, nixos-hardware, home-manager, ... }: let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      overlays = [anyrun.overlay];
      allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./configuration.nix
          ./hosts/laptop/hardware-configuration.nix
          nixos-hardware.nixosModules.dell-xps-15-9500
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.mdray = ./home;
            home-manager.extraSpecialArgs = {inherit inputs;};
          }
        ];
        specialArgs = {inherit inputs;};
      };
    };
  };
}
