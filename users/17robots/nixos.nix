{ pkgs, inputs, ... }:
{
  environment.localBinInPath = true;

  users.users."17robots" = {
    isNormalUser = true;
    home = "/home/17robots";
    extraGroups = ["docker" "wheel"];
    shell = pkgs.bashInteractive;
  };
}
