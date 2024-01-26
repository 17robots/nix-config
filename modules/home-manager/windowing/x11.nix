{ inputs, config, pkgs, lib, ... }:
let
  wm = "i3";
  bar = "";
in
{
  imports = [
    "./wm/${wm}.nix"
    "./bar/${bar}.nix"
  ];
  config = {
    services.dunst.enable = true;
  };
}
