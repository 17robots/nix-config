{ config, pkgs, inputs, ... }: {
  boot.loader.efi.canTouchEfiVariables = true;
  fonts = {
    package = with pkgs; [
      jetbrains-mono
    ];
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
  networking.networkManager.enable = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nixpkgs.config.allowUnfree = true;
  services = {
    tailscale = {
      enable = true;
      extraUpFlags = ["--ssh"];
    };
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };
  time.timeZone = "US/Eastern";
  users.users.17robots = {
    isNormalUser = true;
    extraGroups = [ "audio", "docker", "networkmanager", "wheel", "libvirtd" ];
  };
}
