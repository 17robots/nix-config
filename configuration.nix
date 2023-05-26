{ config, inputs, pkgs, lib, ... }:
let
  inherit (inputs.anyrun.packages.${pkgs.system}) anyrun;
in
{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  documentation = {
    enable = true;
    dev.enable = true;
    doc.enable = true;
    man.enable = true;
  };
  environment = {
    etc = {
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
    };
    systemPackages = with pkgs; [
      anyrun
      appimage-run
      bat
      brightnessctl
      cached-nix-shell
      comma
      ctop
      curlie
      dconf
      ddgr
      dua
      duf
      dunst
      exa
      fd
      fdupes
      ffmpeg
      fzf
      gcc
      gh
      gnumake
      go
      gping
      grim
      hyperfine
      jq
      just
      libnotify
      libreoffice-fresh-unwrapped
      libsixel
      macchina
      man
      most
      nodejs_20
      nodePackages_latest.npm
      nodePackages_latest.pnpm
      notion-app-enhanced
      nushell
      pamixer
      pngquant
      procs
      ripgrep
      rm-improved
      rustup
      scc
      slurp
      speedtest-cli
      starship
      swappy
      swaybg
      tdesktop
      tldr
      topgrade
      transmission-gtk
      tre-command
      unzip
      waybar
      wf-recorder
      wl-clipboard
      xh
      yarn
    ];
    variables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      _JAVA_AWT_WM_NOREPARENTING = "1";
      SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
      DISABLE_QT5_COMPAT = "0";
      GDK_BACKEND = "wayland";
      ANKI_WAYLAND = "1";
      DIRENV_LOG_FORMAT = "";
      WLR_DRM_NO_ATOMIC = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_QPA_PLATFORM_THEME = "qt5ct";
      QT_STYLE_OVERRIDE = "kvantum";
      MOZ_ENABLE_WAYLAND = "1";
      WLR_BACKEND = "vulkan";
      WLR_RENDERER = "vulkan";
      WLR_NO_HARDWARE_CURSORS = "1";
      XDG_SESSION_TYPE = "wayland";
      XDG_CONFIG_HOME = "$HOME/.config";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
    };
  };
  fileSystems = {
    "/".options = ["compress=zstd"];
    "/home".options = ["compress=zstd"];
    "/nix".options = ["compress=zstd" "noatime"];
  };
  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      jetbrains-mono
      iosevka-bin
      noto-fonts
      (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Iosevka Term"
          "Iosevka Term Nerd Font Complete Mono"
          "Iosevka Term Nerd Font"
        ];
        sansSerif = ["Noto Sans"];
        serif = ["Noto Serif"];
      };
    };
  };
  hardware = {
    bluetooth.enable = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.support32Bit = true;
    trackpoint = {
      emulateWheel = true;
      sensitivity = 100;
      speed = 250;
    };
  };
  i18n.defaultLocale = "en_US.UTF-8";
  imports = [
    ./hosts/laptop/hardware-configuration.nix
  ];
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
    };
    firewall.enable = false;
  };
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      max-jobs = "auto";
      keep-going = true;
      log-lines = 20;
      extra-experimental-features = ["flakes" "nix-command" "recursive-nix" "ca-derivations"];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [];
  };
  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        openssl
        curl
        glib
        util-linux
        icu
        libunwind
        libuuid
        zlib
        libsecret
        libglvnd
        libnotify
        SDL2
        vulkan-loader
        gdk-pixbuf
      ];
    };
  };
  security = {
    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };
    polkit.enable = true;
    rtkit.enable = true;
  };
  services = {
    dbus = {
      enable = true;
      packages = with pkgs; [dconf gcr];
    };
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time -c Hyprland";
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
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };
  system = {
    autoUpgrade.enable = false;
    stateVersion = "22.11";
  };
  systemd.services.greetd = {
    serviceConfig = { Type = "idle"; };
    unitConfig = { After = lib.mkOverride 0 ["multi-user.target"]; };
  };
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
  time.timeZone = "US/Eastern";
  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.xdg-portal-hyprland.packages.${pkgs.system}.default
    ];
  };
}
