{ inputs, config, pkgs, lib ... }:
let
  terminal = "alacritty";
in
{
  imports = [
  "./${terminal}.nix"
  ];
}

