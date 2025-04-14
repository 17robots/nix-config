{ pkgs, lib, inputs, ...}: {
  home.packages = with pkgs; [
    wmenu
  ];
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      startup = [
        { command = "wl-paste -t text --watch clipman store --no-persist" }
      ];
    };
  };
}
