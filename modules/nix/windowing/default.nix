{ config, flags, ... }:
{
  imports = [
    ./${flags.windowing}.nix
  ];
}
