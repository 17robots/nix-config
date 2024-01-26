{ flags, ... }:
let
  bar = "waybar";
in
{
  imports = [
    ./bar/${bar}.nix
    ./wm/${flags.wm}.nix
  ];
  config = {
    services.mako.enable = true;
  };
}

