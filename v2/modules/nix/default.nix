{ config, ... }:
{
  imports = [
    ./boot.nix
    ./environment.nix
    ./filesystems.nix
    ./font.nix
    ./hardware.nix
    ./network.nix
    ./nix.nix
    ./security.nix
    ./services.nix
    ./users.nix
    ./xdg.nix
    ./windowing/wayland.nix
    ./wm/sway.nix
  ];
}
