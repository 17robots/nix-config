{ config, pkgs, ... }:
{
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
    firewall.enable = false;
  };
}

