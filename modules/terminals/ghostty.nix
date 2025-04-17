{ pkgs, lib, config, isWSL, ... }: let
  ghosttyPkg = if pkgs.stdenv.isLinux then config.inputs.ghostty.packages.${pkgs.stdenv.system}.default
in {
  programs.ghostty = {
    enable = !isWSL;
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
  };
}
