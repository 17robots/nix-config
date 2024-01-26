{ config, inputs, pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      swaybg
    ];
  }; 
}

