{
  description = "NixOS systems and tools based on mitchellh's config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs, home-manager, ...}@inputs: let
    overlays = [
      inputs.zig.overlays.default
    ];

    mkSystem = import ./lib/mksystem.nix {
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
