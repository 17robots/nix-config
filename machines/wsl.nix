{ pkgs, currentSystemUser, ... }: {
  imports = [
    ./core.nix
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = currentSystemUser;
    startMenuLaunchers = true;
  };
  system.stateVersion = "23.11";
}
