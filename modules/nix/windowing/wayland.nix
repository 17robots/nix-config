{ config, flags, pkgs, ... }:
let
in
{
  imports = [
    ./wm/${flags.wm}.nix
  ];
  environment = {
    systemPackages = with pkgs; [
      slurp
      swappy
      waybar
      wf-recorder
      wl-clipboard
    ];
    variables = {
      ANKI_WAYLAND = "1";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  }; 
}


