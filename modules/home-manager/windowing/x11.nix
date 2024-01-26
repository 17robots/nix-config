{ flags, ... }:
let
  bar = "";
in
{
  imports = [
    ./wm/${flags.wm}.nix
    ./bar/${bar}.nix
  ];
  config = {
    services.dunst.enable = true;
  };
}
