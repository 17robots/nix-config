{ flags, ... }:
let
  browser = "firefox";
in
{
  imports = [
    ./${flags.browser}-${flags.windowing}.nix
  ];
}
