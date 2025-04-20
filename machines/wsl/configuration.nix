{ pkgs, currentUser, ... }: {
  imports = [];
  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = currentUser;
    startMenuLaunchers = true;
  };
  nix = {
    package = pkgs.nixVersions.git;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
