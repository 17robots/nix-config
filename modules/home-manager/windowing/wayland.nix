{ flags, config, pkgs, lib, ... }:
let
  bar = "swaybar";
in
{
  imports = [
    ./bar/${bar}.nix
    ./wm/${flags.wm}.nix
  ];
  config = {
    services.mako.enable = true;
  };
}

