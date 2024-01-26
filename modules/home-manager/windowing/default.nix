{ flags, config, pkgs, lib, ... }:
{
  imports = [
    "./${flags.windowing}.nix"
  ];
}
