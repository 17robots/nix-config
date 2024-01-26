{ inputs, config, pkgs, lib, ... }:
{
  config = {
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-rgba = "rgb";
      };
      gtk2.extraConfig = ''
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-rgba = "rgb";
      '';
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
  };
}
