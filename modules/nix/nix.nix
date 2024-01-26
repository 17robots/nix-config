{ lib, pkgs, ... }:
{
  i18n.defaultLocale = "en_US.UTF-8";
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      max-jobs = "auto";
      keep-going = true;
      log-lines = 20;
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [];
  };
  system = {
    autoUpgrade.enable = false;
    stateVersion = "22.11";
  };
  time.timeZone = "US/Eastern";
}
