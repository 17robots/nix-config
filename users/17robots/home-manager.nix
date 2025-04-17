{isWsl, inputs, shell, desktop, terminal, user, editor, ...}:
{ config, lib, pkgs, ... }: let
  moduleDir = ../../modules
in {
  imports = [
    ./${moduleDir}/git.nix
    ./${moduleDir}/gpg.nix
    ./${moduleDir}/shells/${shell}.nix
    ./${moduleDir}/editors/${editor}.nix
  ] ++ (lib.optionals (!isWsl && pkgs.stdenv.isLinux) [
    ./${moduleDir}/desktops/${desktop}.nix
    ./${moduleDir}/terminals/${terminal}.nix
  ]);
  xdg.enable = true;
  home = {
    homeDirectory = lib.mkForce if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}";
    packages = with pkgs; [
      bash-completion
      bat
      bun
      coreutils
      curl
      eza
      fd
      fundutils
      fzf
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
      tree
      uv
      watch
      zig
    ];
    pointerCursor = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
    };
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      GIT_EDITOR = "nvim";
    };
    username = user;
  };
  programs.direnv.enable = true;
  programs.fonts.fontConfig.enable = true;
  programs.home-manager.enable = true;
  programs.man.enable = true;
  programs.ssh.enable = true;
  programs.ssh.addKeysToAgent = true;
}
