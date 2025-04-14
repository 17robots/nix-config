{
  description = "17robot's nix config";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows  = "nixpkgs";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty.url = "github:ghostty-org/ghostty";
    zig.url = "github:mitchellh/zig-overlay";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    fenix,
    ghostty,
    zig
  } @inputs: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = f:
      builtins.listToAttrs (map (system: {
        name = system;
        value = f system;
      })
      supportedSystems);
    mkPkgs = system: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    fenixPkgs = fenix.packages.${system};
    commonPkgs = with pkgs; [
      git
      bash
      bash-completion
      coreutils
      curl
      (fenixPkgs.stable.withComponents [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ])
      fundutils
      git
      git-lfs
      gnumake
      gnupg
      gnused
      jq
      just
      nodejs
      pinentry-tty
      ripgrep
      tree
      uv
      watch
    ];
    systemSpecificPkgs = if pkgs.stdenv.isLinux then with pkgs; [
      firefox
      pinentry-tty
      tailscale
    ] else with pkgs; [];
    in pkgs.buildEnv {
        name = "home-packages";
        paths = commonPkgs ++ (builtins.filter (p: p != null) systemSpecificPkgs);
    };
  in packages = forAllSystems (system: { default = mkPackages system; });
  nixosConfigurations = {
    laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      systewm = "x86_64-linux";
      modules = [
        ./hosts/base/configuration.nix
        ./hosts/linux/configuration.nix
        ./hosts/linux/laptop/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.17robots.imports = [
            ./home/default.nix
            ./home/hosts/linux/default.nix
          ];
        }
      ];
    };
  };

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
