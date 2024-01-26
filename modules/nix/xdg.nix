{ config, pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
  };
}
