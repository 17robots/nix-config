{ self, pkgs, lib, config, inputs, options, ... }:
with lib; let 
  inherit (inputs.anyrun.packages.${pkgs.system}) anyrun;
  volume = let
    notify-send = pkgs.libnotify + "/bin/notify-send";
    pamixer = lib.getExe pkgs.pamixer;
  in pkgs.writeShellScriptBin "volume" ''
    #!/bin/sh

    ${pamixer} "$@"

    volume="$(${pamixer} --get-volume-human)"

    if [ "$volume = "muted"]; then
      ${notify-send} -r 69 \
        -a "Volume" \
        "Muted" \
        -i ${./mute.svg} \
        -t 888
        -u low
    else
      ${notify-send} -r 69 \
        -a "Volume" "Currently at $volume" \
        -h int:value:"$volume" \
        -i ${./volume.svg} \
        -t 888
        -u low
    fi
  '';
  ocrScript = let
    inherit (pkgs) grim libnotify slurp tesseract5 wl-clipboard;
    _ = lib.getExe;
  in
    pkgs.writeShellScriptBin "wl-ocr" ''
      ${_ grim} -g "$(${_ slurp})" -t ppm - | ${_ tesseract5} - - | ${wl-clipboard}/bin/wl-copy
      ${_ libnotify} "$(${wl-clipboard}/bin/wl-paste)"
    '';
  mkService = lib.recursiveUpdate {
    Unit.After = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
  browser = ["firefox.desktop"];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml-xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;
    "application/json" = browser;
  };
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    #!/bin/bash
    hyprctl keyword animation "fadeOut,0,8,slow" && ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b 5r81acd2)" - | swappy -f -; hyprctl keyword animation "fadeOut,1,8,slow"
  '';
  apply-hm-env = pkgs.writeShellScript "apply-hm-env" ''
    ${lib.optionalString (config.home.sessionPath != []) ''
      export PATH=${builtins.concatStringsSep ":" config.home.sessionPath}:$PATH
    ''}
    ${builtins.concatStringsSep "\n" (lib.mapAttrsToList (k: v: ''
        export ${k}=${v}
      '')
      config.home.sessionVariables)}
    ${config.home.sessionVariablesExtra}
    exec "$@"
  '';
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -1c "exec ${apply-hm-env} $@"
  '';
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  config.home = {
    packages = with pkgs; [
      ocrScript
      run-as-service
      screenshot
    ];
    pointerCursor = {
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "Catppuccin-Mocha-Dark-Cursors";
      gtk.enable = true;
      x11.enable = true;
    };
    sessionVariables = {
      XCURSOR_SIZE = "16";
    };
    stateVersion = "22.11";
  };
  config.programs = {
    bat = {
      enable = true;
      config.pager = "less -FR";
      config.theme = "Catppuccin-mocha";
      themes.Catppuccin-mocha = builtins.readFile(pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-mocha.tmTheme";
        hash = "sha256-qMQNJGZImmjrqzy7IiEkY5IhvPAMZpq0W6skLLsng/w=";
      });
    };
    dircolors.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    exa.enable = true;
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
        extraPolicies = {
          ExtensionSettings = {};
        };
      };
    };
    git = {
      delta.enable = true;
      enable = true;
      extraConfig = {
        delta.line-numbers = true;
        init.defaultBranch = "main";
        branch.autosetupmerge = "true";
        push.default = "current";
        merge.stat = "true";
        core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        repack.usedeltabaseoffset = "true";
        pull.ff = "only";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          autoupdate = true;
          autoStash = true;
        };
      };
      lfs.enable = true;
      userName = "17robots";
      userEmail = "mdray@ameritech.net";
    };
    gpg.enable = true;
    helix = {
      enable = true;
      package = inputs.helix.packages."x86_64-linux".default;
      settings = {
        editor = {
          color-modes = true;
          cursorline = true;
          mouse = true;
          idle-timout = 1;
          line-number = "relative";
          scrolloff = 5;
          bufferline = "always";
          lsp = {
            display-messages = true;
            display-inline-hints = true;
          };
          true-color = true;
          rulers = [80];
          soft-wrap.enable = true;
          indent-guides = {
            render = true;
          };
          gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
          statusline = {
            left = [];
            center = [];
            right = [];
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "block";
          };
        };
      };
      languages = with pkgs; [];
    };
    man.enable = true;
    nushell.enable = true;
    starship = {
      enable = true;
      git_commit = {commit_hash_length=4;};
      hostname = {
        ssh_only = true;
        format = "[$hostname](bold blue) ";
        disabled = false;
      };
      line_break.disabled = false;
      settings = {
        add_newline = false;
        scan_timeout = 5;
      };
    };
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "left";
          width = 60;
          spacing = 7;
          modules-left = [];
          modules-center = [];
          modules-right = ["clock" "pulseaudio" "battery"];
          clock = {
            format = ''
              {:%H
              %M}'';
          };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}";
            format-charging = "";
            format-plugged = "";
            format-alt = "{icon}";
            format-icons = ["" "" "" "" "" "" "" "" "" "" "" ""];
          };
          pulseaudio = {
            scroll-step = 5;
            tooltip = false;
            format = "{icon}";
            format-icons = {default = ["" "" "墳"];};
            on-click = "killall pauvcontrol || pauvcontrol";
          };
        };
      };
    };
  };
  config.services = {
    dunst = {
      enable = true;
      iconTheme = {
        package = self.packages.${pkgs.system}.catppuccin-folders;
        name = "Papirus";
      };
      package = pkgs.dunst.overrideAttrs (oldAttrs: {
        src = pkgs.fetchFromGitHub {
          owner = "sioodmy";
          repo = "dunst";
          rev = "6477864bd870dc74f9cf76bb539ef89051554525";
          sha256 = "FCoGrYipNOZRvee6Ks5PQB5y2IvN+ptCAfNuLXcD8Sc=";
        };
      });
      settings = {
        global = {
          frame_color = "#f4b8e4";
          separator_color = "#f4b8e4";
          width = 220;
          height = 220;
          offset = "0x15";
          font = "Iosevka 16";
          corner_radius = 10;
          origin = "top-center";
          notification_limit = 3;
          idle_threshold = 120;
          ignore_newline = "no";
          mouse_left_click = "close_current";
          mouse_right_click = "close_all";
          sticky_history = "yes";
          history_length = 20;
          show_age_threshold = 60;
          ellipsize = "middle";
          padding = 10;
          always_run_script = true;
          frame_width = 3;
          transparency = 10;
          progress_bar = true;
          progress_bar_frame_width = 0;
          hightlight = "#f4b8e4";
        };
        fullscreen_delay_everything.fullscreen = "delay";
        urgency_low = {
          background = "#1e1e2e";
          foreground = "#c6d0f5";
          timeout = 5;
        };
        urgency_normal = {
          background = "#1e1e2e";
          foreground = "#c6d0f5";
          timeout = 6;
        };
        urgency_critical = {
          background = "#1e1e2e";
          foreground = "#c6d0f5";
          frame_color = "#ea999c";
          timeout = 0;
        };
      };
    };
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
      enableSshSupport = true;
    };
  };
  config.systemd.user = {
    services = {
      cliphist = mkService {
        Unit.Description = "Clipboard History";
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste -- watch ${lib.getExe pkgs.cliphist} store";
          Restart = "always";
        };
      };
      swaybg = mkService {
        Unit.Description = "Wallpaper Chooser";
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -i ${./hyprland/wall.png}";
          Restart = "always";
        };
      };
    };
    target = {
      hyprland-session.wants = [ "xdg-desktop-autostart.target" ];
      tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = ["graphical-session-pre.target"];
        };
      };
    };
  };
  config.wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.default;
    systemdIntegration = true;
    extraConfig = builtins.readFile ./hyprland/hyprland.conf;
  };
  options = {
    gtk = {
      enable = true;
      theme = {
        name = "";
        package = pkgs.catppuccin-gtk.override {
          size = "compact";
          tweaks = ["black" "rimless"];
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "Lexend";
        size = 13;
      };
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstype = "hintslight";
        gtk-xft-rgba = "rgb";
      };
      gtk2.extraConfig = ''
        gtk-xft-antialias = 1
        gtk-xft-hinting = 1
        gtk-xft-hintstype = "hintslight"
        gtk-xft-rgba = "rgb"
      '';
    };
    xdg = {
      configFile = {
        "anyrun/config.ron".text = ''
          Config(
            width: Fraction(0.3),
            position: Center,
            vertical_offset: Absolute(15),
            hide_icons: false,
            ignore_exclusive_zones: false,
            layer: Overlay,
            hide_plugin_info: true,
            plugins: [
              "${anyrun}/lib/libapplications.so",
              "${anyrun}/lib/librandr.so",
              "${anyrun}/lib/librink.so",
              "${anyrun}/lib/libshell.so",
              "${anyrun}/lib/libsymbols.so",
              "${anyrun}/lib/libtranslate.so",
            ],
          )
        '';
        "anyrun/style.css".text = ''
          * {
            transition: 200ms ease-out;
            font-family: Lexend;
          }
          #window,#match,#entry,#plugin,#main {
            background: transparent;
          }
          #match: {
            padding: 3px;
            border-radius: 16px;
          }
          #match:selected {
            background: rgba(203, 166, 247, 0.7);
          }
          #entry {
            border-radius: 16px;
          }
          box#main {
            background: rgba(30, 30, 46, 0.7);
            border: 1px solid #28283d;
            border-radius: 24px;
            padding: 8px;
          }
          row:first-child {
            margin-top: 6px;
          }
        '';
        "Kvantum/catppuccin/catppuccin.kvconfig".source = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Pink/Catppuccin-Mocha-Pink.kvconfig";
          sha256 = "13ci6bzi41pazvpbylwqxhwjv4w8af50g26qqfh3xbaxjwfgdk1d";
        };
        "Kvantum/catppuccin/catppuccin.svg".source = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/catppuccin/Kvantum/main/src/Catppuccin-Mocha-Pink/Catppuccin-Mocha-Pink.svg";
          sha256 = "1rlxd9w2ifddc62rdyddzdbglc64wf7k6w7hlxfy85hwmn35m683";
        };
        "Kvantum/kvantum.kvconfig".text = ''
          [General]
          theme=catppuccin

          [Applications]
          catppuccin=Dolphin, dolphin, Nextcloud, nextcloud, qt5ct, org.kde.dolphin, org.kde.kalendar, kalendar, Kalendar, qbittorent, org.qbittorrent.qBittorent
        '';
        "waybar/style.css".text = import ./waybar/style.nix;    
      };
      enable = true;
      mimeApps = {
        associations.added = associations;
        defaultApplications = associations;
        enable = true;
      };
      userDirs = {
        enable = true;
      };
    };
  };
}
