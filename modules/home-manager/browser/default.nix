{ inputs, config, pkgs, lib, windowing, ... }:
let
  browser = "firefox";
in
{
  imports = [
    "${inputs.browser}-${inputs.windowing}"
  ];
}
