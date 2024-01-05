{ config, pkgs, ... }:
{
  users.users.mdray = {
    extraGroups = [
      "audio"
      "docker"
      "gitea"
      "input"
      "lp"
      "networkmanager"
      "nix"
      "plugdev"
      "power"
      "systemd-journal"
      "vboxusers"
      "video"
      "wheel"
      "wireshark"
    ];
    isNormalUser = true;
    shell = pkgs.nushell;
  };
}
