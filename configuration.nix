{ config, inputs, pkgs, lib, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      appimage-run
      bemenu
      brightnessctl
      bun
      cached-nix-shell
      ctop
      dconf
      discord
      docker-compose
      dua
      duf
      fd
      fdupes
      ffmpeg
      fnm
      gcc
      just
      libnotify
      libsixel
      most
      nix-ld
      nodePackages_latest.pnpm
      openssl
      pamixer
      pkg-config
      pngquant
      procs
      rustup
      scc
      unzip
      xh
    ];
    variables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      _JAVA_AWT_WM_NOREPARENTING = "1";
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      DISABLE_QT5_COMPAT = "0";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORM_THEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_CONFIG_HOME = "$HOME/.config";
    };
  };
  imports = [
    ./modules/system.nix
    ./modules/wayland/sway.nix
  ];
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
    firewall.enable = false;
  };
}
