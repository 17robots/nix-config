{pkgs, ...}: {
  imports = [];

  home.packages = with pkgs; [
    bat,
    fd,
    fnm,
    fzf,
    htop,
    jq,
    ripgrep,
    tree,
    zigpkgs."0.14.0"
  ];
  home.pointerCursor = {
    package = pkgs.vanilla-dmz;
    name = "Vanilla-DMZ";
  };
}
