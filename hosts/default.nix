{ nixpkgs, self, ...}:
let 
  inherit (self) inputs;
  hw = inputs.nixos-hardware.nixosModules;
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
      ./configuration.nix
      ../home
      {inherit home-manager;}
      hw.dell-xps-15-9500
    ];
    specialArgs = {inherit inputs;};
  };
}