{ inputs, config, pkgs, lib, ... }:
{
  config = {
    programs = {
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "bottom";
            spacing = 7;
            modules-left = [];
            modules-center = [];
            modules-right = ["clock" "pulseaudio" "battery"];
            clock = {
              format = ''
                {:%H
                %M}'';
            };
            battery = {
              states = {
                warning = 30;
                critical = 15;
              };
            };
            pulseaudio = {
              scroll-step = 5;
              tooltip = false;
              format = "{icon}";
              format-icons = {default = ["" "" "墳"];};
              on-click = "killall pauvcontrol || pauvcontrol";
            };
          };
        };
      };
    };
  };
}
