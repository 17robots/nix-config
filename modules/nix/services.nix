{ config, lib, pkgs, ... }:
{
  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr];
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -c sway";
          user = "mdray";
        };
      };
    };
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
  systemd.services.greetd = {
    serviceConfig = { Type = "idle"; };
    unitConfig = { After = lib.mkOverride 0 ["multi-user.target"]; };
  };
}
