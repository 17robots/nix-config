{
  description = "17robot's nix config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nvim-config.url = "github:17robots/nvim-config";
    nvim-config.flake = false;
  };
  outputs = { self, nixpkgs, home-manager, nvim-config, ... }@inputs: let
    overlays = [];
    mkSystem = import ./lib/mkSys.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    nixosConfigurations.laptop = mkSystem "laptop" {
      system = "x86_64-linux";
      user = "17robots";
    };
    nixosConfigurations.wsl = mkSystem "wsl" {
      system = "x86_64-linux";
      user = "17robots";
      wsl = true;
    };
  };
}
