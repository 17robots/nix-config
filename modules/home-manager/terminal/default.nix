{ flags, ... }:
{
  imports = [
  ./${flags.terminal}.nix
  ];
}

