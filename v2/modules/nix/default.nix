{ config, ... }:
{
  imports = [
    ./boot
    ./environment
    ./filesystems
    ./font
    ./hardware
    ./nix
    ./security
    ./services
    ./users
    ./xdg
    ./windowing/wayland
    ./wm/sway
  ];
}
