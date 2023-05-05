{
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:Nixos/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, xdg-portal-hyprland }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.dell-xps-15-9500
        home-manager.nixosModules.home-manager {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            users.mdray = ./home;
          };
        }
      ];
      specialArgs = {inherit (self) inputs;};
    };
  };
}
