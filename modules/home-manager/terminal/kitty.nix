{ config, ... }:
{
  config = {
    programs = {
      kitty = {
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


