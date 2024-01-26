{ config, inputs, pkgs, lib, ... }:
{
  services.xserver.displayManager = {
    defaultSession = "none+i3";
  };
}
