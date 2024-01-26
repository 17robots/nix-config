{ flags, config, ... }:
{
  imports = [
  ./${flags.terminal}.nix
  ];
}

