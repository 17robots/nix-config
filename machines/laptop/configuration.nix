{ config, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ../common.nix
  ];
  networking.networkManager.wifi.macAddress = "random";
  pulseaudio.enable = true;
  pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.polkit.enable = true;
  # system state version here
}
