{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    "./${inputs.windowing}.nix"
  ];
}
