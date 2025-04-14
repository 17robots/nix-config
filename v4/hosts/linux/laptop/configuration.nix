{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../desktops/wayland.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
  };
  networking.hostname = "nix";
  networking.networkManager = {
    wifi.macAddress = "random";
  };
  security.rkit.enable = true;
  system.stateVersion = "24.11";
}
