{ config, pkgs, inputs, ... }: let homeDir = if pkgs.stdenv.isLinux then "/home/17robots" else "/Users/17robots"; in {
  users.users.17robots = {};
  nix = {
    enable = true;
    optimise.automatic = true;
    settings.experimental-features = ["nix-command", "flakes"];
    package = pkgs.nixVersions.stable;
  };
  environment.systemPackages = [inputs.self.packages.${pkgs.system}.default];
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    dmenu
  ];
}
