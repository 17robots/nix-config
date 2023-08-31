{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ./waybar
  ];
  config = {
    services.mako.enable = true;
  };
}
