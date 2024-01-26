{ flags, ... }:
{
 imports = [
  ./wm/${flags.wm}.nix
 ];
 services.xserver = {
  enable = true;
  autorun = false;
  layout = "us";
 };
}
