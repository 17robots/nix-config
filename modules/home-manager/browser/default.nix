{ flags, ... }:
let
  browser = "firefox";
in
{
  imports = [
    "${flags.browser}-${inputs.windowing}"
  ];
}
