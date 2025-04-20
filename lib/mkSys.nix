{ nixpkgs, overlays, inputs, ... }:
name: {
  system,
  user,
  shell ? "bash",
  darwin ? false,
  wsl ? false,
  terminal ? "ghostty",
  desktop ? "sway",
  editor ? "neovim"
}: let
machineConfig = ../machines/${name}/configuration.nix;
userOSConfig = ../users/${user}/${if darwin then "darwin" else "nixos" }.nix;
userHMConfig = ../users/${user}/home-manager.nix;
systemFunc = if darwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
home-manager = if darwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {
  inherit system;
  modules = [
    { nixpkgs.overlays = overlays; }

    (if wsl then inputs.nixos-wsl.nixosModules.wsl else {})

    machineConfig
    userOSConfig
    home-manager.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig {
        currentUser = user;
        isWSL = wsl;
        inputs = inputs;
        terminal = terminal;
        desktop = desktop;
        editor = editor;
	shell = shell;
      };
    }
    {
      config._module.args = {
        currentSystem = system;
        currentName = name;
        currentUser = user;
        isWSL = wsl;
        inputs = inputs;
        terminal = terminal;
        desktop = desktop;
        editor = editor;
      	shell = shell;
      };
    }
  ];
}
