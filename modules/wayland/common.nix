{ config, inputs, pkgs, lib, ... }:
{
 environment = {
    systemPackages = with pkgs; [
      waybar
      wf-recorder
      wl-clipboard
    ];
    variabls = {
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

