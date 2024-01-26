{ flags, ... }:
{
  imports = [
    ./${flags.windowing}.nix
  ];
}
