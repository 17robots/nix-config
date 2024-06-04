{ config, pkgs, lib, currentSystem, currentSystemName }:
{
  imports = [
    ./pc-shared.nix
    ./hardware/laptop.nix
  ];
  hardware.trackpoint = {
    emulateWheel = true;
    sensitivity = 100;
    speed = 250;
  };
}
