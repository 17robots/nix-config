{ inputs, config, pkgs, lib, ... }:
let
  wm = "sway";
  bar = "swaybar";
in
{
  imports = [
    ./bar/${bar}.nix
    ./wm/${wm}.nix
  ];
  config = {
    services.mako.enable = true;
  };
}

