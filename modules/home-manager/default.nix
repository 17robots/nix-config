{ pkgs, lib, ... }:
with lib; {
  imports = [
    ./browser
    ./common
    ./terminal
    ./windowing
  ];
  config = {
    home = {
      packages = with pkgs;
      [
        bun
        mods
      ];
      sessionVariables = {
        XCURSOR_SIZE = "8";
      };
      stateVersion = "22.11";
    };
    xdg.enable = true;
  };
}

