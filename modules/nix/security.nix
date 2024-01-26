{ pkgs, ... }:
{
  security = {
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };
    polkit.enable = true;
    rtkit.enable = true;
  };
}
