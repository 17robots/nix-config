{ nixpkgs, self, ...}:
let 
  inherit (self) inputs;
  main = ./configuration.nix;
  home = ../home;
  hw = inputs.nixos-hardware.nixosModules;
  hmModule = inputs.home-manager.nixosModules.home-manager;
  shared = [main];

  home-manager = {
    useUserPackages = true;
    useGlobalPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
  };
in {
  laptop = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      {networking.hostName = "nixos";}
      ./laptop/hardware-configuration.nix
      main
      home
      {inherit home-manager;}
      hmModule
      hw.dell-xps-15-9500
    ] ++ shared;
    specialArgs = {inherit inputs;};
  };
}