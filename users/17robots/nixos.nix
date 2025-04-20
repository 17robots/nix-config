{ pkgs, inputs, ... }: {
  environment.localBinInPath = true;
  users.users."17robots" = {
    isNormalUser = true;
    extraGroups = [ "audio" "docker" "networkmanager" "wheel" "libvirtd" ];
    shell = pkgs.bash;
  };
}
