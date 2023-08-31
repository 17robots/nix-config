{ config, inputs, pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      swaybg
    ];
  }; 
  imports = [
    ../common.nix
  ];
}
