{ config, pkgs, lib, currentSystem, currentSystemName, ... }:
{
  environment = {
    shells = with pkgs; [ bashInteractive ];
    systemPackages = with pkgs; [
      cachix
      fd
      gnumake
      openssl
      pkg-config
    ];
    variables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
    };
  };
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    package = pkgs.nixVersions.git;
  };
}
