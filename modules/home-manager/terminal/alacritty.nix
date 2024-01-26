{ config, ... }:
{
  config = {
    programs = {
      alacritty = {
        enable = true;
        settings.font = {
          family = "JetbrainsMono";
          size = 10;
        };
      };
    };
  };
}
