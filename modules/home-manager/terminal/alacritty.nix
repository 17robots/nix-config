{ config, ... }:
{
  config = {
    programs = {
      alacritty = {
        enable = true;
        font = {
          name = "JetbrainsMono";
          size = 10;
        };
        theme = "Rosé Pine";
      };
    };
  };
}
