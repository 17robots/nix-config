{ inputs, config, pkgs, lib, ... }:
{
  config = {
    home = {
      packages = with pkgs; [
        firefox-wayland
      ];
    };
  };
}
