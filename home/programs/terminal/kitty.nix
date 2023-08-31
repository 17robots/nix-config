{ inputs, config, pkgs, lib, ... }:
{
  config = {
    programs = {
      kitty = {
        enable = true;
        font = {
          name = "JetbrainsMono";
          size = 10;
        };
        settings = {
          background_opacity = "0.9";
          foreground = "#979eab";
          background = "#282c34";
          cursor = "#cccccc";
          color0 = "#282c34";
          color1 = "#e06c75";
          color2 = "#98c379";
          color3 = "#e5c07b";
          color4 = "#61afef";
          color5 = "#be5046";
          color6 = "#56b6c2";
          color7 = "#979eab";
          color8 = "#393e48";
          color9 = "#d19a66";
          color10 = "#56b6c2";
          color11 = "#e5c07b";
          color12 = "#61afef";
          color13 = "#be5046";
          color14 = "#56b6c2";
          color15 = "#abb2bf";
          selection_foreground = "#282c34";
          selection_background = "#979eab";         
        };
      };
    };
  };
}
