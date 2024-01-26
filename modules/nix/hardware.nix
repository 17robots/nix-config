{ pkgs, ... }:
{
  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.support32Bit = true;
    trackpoint = {
      emulateWheel = true;
      sensitivity = 100;
      speed = 250;
    };
  };
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  virtualisation = {
    docker.enable = true;
  };
}
