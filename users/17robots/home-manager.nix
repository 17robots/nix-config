{ isWSL, inputs, ... }:
{ config, lib, pkgs, ... }:
let
  isLinux = pkgs.stdenv.isLinux;
  manpager = (pkgs.writeShellScriptBin "manpager" (''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {
  home.stateVersion = "23.11";

  xdg.enable = true;

  home.packages = [
    pkgs.bat
    pkgs.fd
    pkgs.fzf
    pkgs.gh
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.zigpkgs."0.12.0"
    pkgs.nodejs
  ] ++ (lib.optionals (isLinux && !isWSL) [
    pkgs.firefox
    pkgs.wofi
  ]);

  home.sessionVariables = {
    LANG = "";
    LC_CTYPE = "";
    LC_ALL = "";
    EDITOR = "nvim";
    MANPAGER = "${manpager}/bin/manpager";
  };

  programs.gpg.enable = true;
  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = ["ignoredups" "ignorespace"];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
    };
  };
  programs.direnv = {
    enable = true;

  };

  programs.git = {
    enable = true;
    userName = "17robots";
    userEmail = "mdray@duck.com";
    signing = {
      key = "";
      signByDefault = true;
    };
    aliases = {
      cleanup = "";
      prettylog = "";
      root = "";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = "";
      credential.helper = "store";
      github.user = "17robots";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "1";
    secureSocket = false;
    extraConfig = ''
      set -ga terminal-overrides ",*256col*:TC"

      set -g @dracula-show-battery false
      set -g @dracula-show-network false
      set -g @dracula-show-weather false

      bind -n C-k send-keys "clear"\; send-keys "Enter"
    '';
  };

  programs.alacritty = {
    enable = !isWSL;
    settings = {
      env.TERM = "xterm-256color";
    };
  };

  programs.kitty = {
    enable = !isWSL && false;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;

    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };

  wayland.windowManager.sway = {
    enable = !isWSL;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
    };
  };
}
