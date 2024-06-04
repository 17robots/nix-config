{ config, pkgs, lib, currentSystem, currentSystemName, ... }:
{
  imports = [
    ./core.nix
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.enable = true;
  };
  environment = {
    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      mako
    ];
  };
  fonts = {
    package = [
      pkgs.jetbrains-mono
    ];
  };
  hardware = {
    bluetooth.enable = true;
    pulseaudio.support32Bit = true;
  };
  i18n.defaultLocale = "en_US.UTF-8";
  networking.hostName = "nix";
  networking.networkManager = {
    enable = true;
    wifi.macAddress = "random";
  };
  networking.firewall.enable = false;
  services = {
    journald.extraConfig = ''
      SystemMaxUse=50M
      RuntimeMaxUse=10M
    '';
    openssh.enable = true;
    printing.enable = true;
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      audio.enable = true;
      enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
  securiry.polkit.enable = true;
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  time.timeZone = "US/Eastern";
  virtualisation.docker.enable = true;
}
