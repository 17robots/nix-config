{ currentUser, isWSL, shell, desktop, terminal, editor, inputs, ...}:
{ config, lib, pkgs, ... }: let
  moduleDir = ../../modules;
in {
  imports = [
    "${moduleDir}/git.nix"
    "${moduleDir}/shells/${shell}.nix"
    "${moduleDir}/editors/${editor}.nix"
  ] ++ (lib.optionals (!isWSL && pkgs.stdenv.isLinux) [
    "${moduleDir}/desktops/${desktop}.nix"
    "${moduleDir}/terminals/${terminal}.nix"
    "${moduleDir}/gpg.nix"
  ]);
  xdg.enable = true;
  xdg.configFile."nvim".source = inputs.nvim-config.outPath;
  home = {
    packages = with pkgs; [
      bash-completion
      bat
      bun
      coreutils
      curl
      eza
      fd
      findutils
      fzf
      gcc
      git
      git-lfs
      gnumake
      gnupg
      gnused
      htop
      jq
      just
      nodejs
      ripgrep
      rustup
      tree
      unzip
      uv
      watch
      zig
    ];
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
    stateVersion = "24.11";
    username = currentUser;
  };
  programs.direnv.enable = true;
  programs.home-manager.enable = true;
  programs.man.enable = true;
  programs.ssh.enable = true;
}
