{ pkgs, lib, inputs, ...}: let
    homeDir = if pkgs.stdenv.isLinux then "/home/17robots" else "/Users/17robots";
    ghosttyPkg = if pkgs.stdenv.isLinux then inputs.ghostty.packages.${pkgs.stdenv.system}.default
in {
    imports = [
      ./programs/bash.nix
      ./programs/git.nix
    ];
    home = {
      username = "17robots";
      homeDirectory = lib.mkForce homeDir;
      stateVersion = "25.05";
    };
    programs = {
      fonts.fontConfig.enable = true;
      ghostty = {
        enable = true;
        package = ghosttyPkg;
        settings = {
          font-family = "JetBrains Mono NF";
          font-size = 10;
          theme = "nord";
          window-theme = "dark";
          window-padding-balance = true;
          window-padding-color = "background";
          window-padding-x = 5;
          window-padding-y = 5;
          window-decoration = false;
          gtk-titlebar = false;
          gtk-tabs-location = "bottom";
          gtk-wide-tabs = false;
          clipboard-read = "allow";
          clipboard-write = "allow";
        };
        enableBashIntegration = true;
      };
      home-manager.enable = true;
      man.enable = true;
      ssh.enable = true;
      ssh.addKeysToAgent = true;
    };
}
