{ pkgs, lib, inputs, isWsl, ...}: {
  home.packages = with pkgs; [
    clipman
    wmenu
  ];
  wayland.windowManager.sway = {
    enable = !isWSL;
    config = rec {
      modifier = "Mod4";
      terminal = "ghostty";
      startup = [
        { command = "wl-paste -t text --watch clipman store --no-persist" }
      ];
    };
  };
}

