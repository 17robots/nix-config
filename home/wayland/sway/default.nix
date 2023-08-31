{ inputs, config, pkgs, lib, ... }:
with lib; let
  mkService = lib.recursiveUpdate {
    Unit.After = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  imports = [
    ../common.nix
  ];
  config = {
    systemd.user = {
      services = {
        swaybg = mkService {
          Unit.Description = "Wallpaper Chooser";
          Service = {
            ExecStart = "${lib.getExe pkgs.swaybg} -i ${../../bg/wall.png}";
            Restart = "always";
          };
        };
      };
    };
    wayland.windowManager.sway = {
      config = {
        gaps = {
          inner = 5;
          outer = 5;
        };
        menu = "bemenu-run";
        modifier = "Mod4";
        terminal = "kitty";
      };
      enable = true;
      extraConfig = ''
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10
        bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
        bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
        bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
      '';
    };
  };
}
