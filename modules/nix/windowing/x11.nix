{ config, inputs, pkgs, lib, ... }:
let
  wm = "i3";
in
{
 imports = [
  "./wm/${wm}.nix"
 ];
 services.xserver = {
  enable = true;
  autorun = false;
  layout = "us";
 };
}
