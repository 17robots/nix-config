{ inputs, config, pkgs, lib, ... }:
with lib; let
  inherit (inputs.anyrun.packages.${pkgs.system}) anyrun;
  mkService = lib.recursiveUpdate {
    Unit.After = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
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

  # runs processes as systemd transient services
  run-as-service = pkgs.writeShellScriptBin "run-as-service" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --slice=app-manual.slice \
      --property=ExitType=cgroup \
      --user \
      --wait \
      bash -lc "exec ${apply-hm-env} $@"
  '';
  in {
  imports = [];
  config = {
    gtk = {
      enable = true;
      gtk3.extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-rgba = "rgb";
      };
      gtk2.extraConfig = ''
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-rgba = "rgb";
      '';
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };
    home = {
      packages = [run-as-service];
      sessionVariables = {
        XCURSOR_SIZE = "8";
      };
      stateVersion = "22.11";
    };
    programs = {
      bat = {
        enable = true;
        config.pager = "less -FR";
      };
      btop.enable = true;
      dircolors.enable = true;
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      exa.enable = true;
      firefox = {
        enable = true;
        package = (pkgs.wrapFirefox) pkgs.firefox-unwrapped {
          extraPolicies = {
            CaptivePortal = false;
            DisableFirefoxStudio = true;
            DisablePocet = true;
            DisableTelemetry = true;
            DisableFirefoxAccounts = true;
            DisableFormHistory = true;
            DisplayBookmarksToolbar = false;
            DontCheckDefaultBrowser = true;
            SearchEngines = {
              Default = "DuckDuckGo";
              Remove = [
                "Google"
                "Bing"
                "Amazon.com"
                "eBay"
                "Twitter"
                "Wikipedia"
              ];
            };
            FirefoxHome = {
              Pocket = false;
              Snippets = false;
            };
            PasswordManagerEnabled = false;
            PromptForDownloadLocations = true;
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
            SanitizeOnShutdown = {
              Cache = true;
              History = true;
              Cookies = true;
              Downloads = true;
              FormData = true;
              Sessions = true;
              OfflineApps = true;
            };
            Preferences = {
              "browser.toolbars.bookmarks.visibility" = "never";
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1,1.1,1.2";
              "browser.uidensity" = 1;
              "privacy.webrtc.legacyGlobalIndicator" = false;
              "http://127.0.0.1/" = "http://127.0.0.1/";
              "app.vendorURL" = "http://127.0.0.1/";
              "app.privacyURL" = "http://127.0.0.1/";
              "plugins.hide_infobar_for_missing_plugin" = true;
              "plugins.hide_infobar_for_outdated_plugin" = true;
              "plugins.notifyMissingFlash" = false;
              "network.http.pipelining" = true;
              "network.http.proxy.pipelining" = true;
              "network.http.pipelining.maxrequests" = 10;
              "nglayout.initialpaint.delay" = 0;
              "network.cookie.cookieBehavior" = 1;
              "privacy.firstparty.isolate" = true;
              # tor
              # "network.proxy.socks" = "127.0.0.1";
              # "network.proxy.socks_port" = 9050;
              "extensions.update.enabled" = false;
              "intl.locale.matchOS" = true;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.EULA.override" = true;
              "extensions.autoDisableScopes" = 3;
              "extensions.shownSelectionUI" = true;
              "extensions.blocklist.enabled" = false;
              "app.update.url" = "http://127.0.0.1/";
              "startup.homepage_welcome_url" = "";
              "browser.startup.homepage_override.mstone" = "ignore";
              "app.support.baseURL" = "http://127.0.0.1/";
              "app.support.inputURL" = "http://127.0.0.1/";
              "app.feedback.baseURL" = "http://127.0.0.1/";
              "browser.uitour.url" = "http://127.0.0.1/";
              "browser.uitour.themeOrigin" = "http://127.0.0.1/";
              "plugins.update.url" = "http://127.0.0.1/";
              "browser.customizemode.tip0.learnMoreUrl" = "http://127.0.0.1/";
              "browser.dictionaries.download.url" = "http://127.0.0.1/";
              "browser.search.searchEnginesURL" = "http://127.0.0.1/";
              "layout.spellcheckDefault" = 0;
              "browser.download.useDownloadDir" = false;
              "browser.aboutConfig.showWarning" = false;
              "browser.translation.engine" = "";
              "media.gmp-provider.enabled" = false;
              "browser.urlbar.update2.engineAliasRefresh" = true;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.showSponsored" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
              "browser.urlbar.suggest.engines" = false;
              "browser.urlbar.suggest.topsites" = false;
              "security.OCSP.enabled" = 0;
              "security.OCSP.require" = false;
              "browser.discovery.containers.enabled" = false;
              "browser.discovery.enabled" = false;
              "services.sync.prefs.sync.browser.startup.homepage" = false;
              "browser.contentblocking.report.monitor.home_page_url" = "http://127.0.0.1/";
              "dom.ipc.plugins.flash.subprocess.crashreporter.enabled" = false;
              "browser.safebrowsing.enabled" = false;
              "browser.safebrowsing.downloads.remote.enabled" = false;
              "browser.safebrowsing.malware.enabled" = false;
              "browser.safebrowsing.provider.google.updateURL" = "";
              "browser.safebrowsing.provider.google.gethashURL" = "";
              "browser.safebrowsing.provider.google4.updateURL" = "";
              "browser.safebrowsing.provider.google4.gethashURL" = "";
              "browser.safebrowsing.provider.mozilla.gethashURL" = "";
              "browser.safebrowsing.provider.mozilla.updateURL" = "";
              "services.sync.privacyURL" = "http://127.0.0.1/";
              "social.enabled" = false;
              "social.remote-install.enabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.healthreport.about.reportUrl" = "datareporting.healthreport.about.reportUrl";
              "datareporting.healthreport.documentServerURI" = "http://127.0.0.1/";
              "healthreport.uploadEnabled" = false;
              "social.toast-notifications.enabled" = false;
              "datareporting.healthreport.service.enabled" = false;
              "browser.slowStartup.notificationDisabled" = true;
              "network.http.sendRefererHeader" = 2;
              "network.http.referer.spoofSource" = true;
              "network.http.originextension" = false;
              "dom.event.clipboardevents.enabled" = true;
              "network.user_prefetch-next" = false;
              "network.dns.disablePrefetch" = true;
              "network.http.sendSecureXSiteReferrer" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.server" = "";
              "experiments.manifest.uri" = "";
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "plugins.enumerable_names" = "";
              "plugin.state.flash" = 0;
              "browser.search.update" = false;
              "dom.battery.enabled" = false;
              "device.sensors.enabled" = false;
              "camera.control.face_detection.enabled" = false;
              "camera.control.autofocus_moving_callback.enabled" = false;
              "network.http.speculative-parallel-limit" = 0;
              "browser.urlbar.userMadeSearchSuggestionsChoice" = true;
              "browser.search.suggest.enabled" = false;
              "browser.sessionstore.max_resumed_crashes" = 0;
              "security.certerrors.mitm.priming.enabled" = false;
              "security.certerrors.recordEventTelemetry" = false;
              "extensions.shield-recipe-client.enabled" = false;
              "browser.newtabpage.directory.source" = "";
              "browser.newtabpage.directory.ping" = "";
              "browser.newtabpage.introShown" = true;
              "privacy.trackingprotection.enabled" = false;
              "privacy.trackingprotection.pbmode.enabled" = false;
              "urlclassifier.trackingTable" = "test-track-simple,base-track-digest256,content-track-digest256";
              "privacy.donottrackheader.enabled" = false;
              "privacy.trackingprotection.introURL" = "https://www.mozilla.org/%LOCALE%/firefox/%VERSION%/tracking-protection/start/";
              "geo.enabled" = false;
              "geo.wifi.uri" = "";
              "browser.search.geoip.url" = "";
              "browser.search.geoSpecificDefaults" = false;
              "browser.search.geoSpecificDefaults.url" = "";
              "browser.search.modernConfig" = false;
              "captivedetect.canonicalURL" = "";
              "network.captive-portal-service.enabled" = false;
              "privacy.resistFingerprinting" = true;
              "webgl.disabled" = true;
              "privacy.trackingprotection.cryptomining.enabled" = true;
              "privacy.trackingprotection.fingerprinting.enabled" = true;
              "gecko.handlerService.schemes.mailto.0.name" = "";
              "gecko.handlerService.schemes.mailto.1.name" = "";
              "handlerService.schemes.mailto.1.uriTemplate" = "";
              "gecko.handlerService.schemes.mailto.0.uriTemplate" = "";
              "browser.contentHandlers.types.0.title" = "";
              "browser.contentHandlers.types.0.uri" = "";
              "browser.contentHandlers.types.1.title" = "";
              "browser.contentHandlers.types.1.uri" = "";
              "gecko.handlerService.schemes.webcal.0.name" = "";
              "gecko.handlerService.schemes.irc.0.name" = "";
              "gecko.handlerService.schemes.irc.0.uriTemplate" = "";
              "gecko.handlerService.schemes.webcal.0.uriTemplate" = "";
              "extensions.webservice.discoverURL" = "http://127.0.0.1/";
              "extensions.getAddons.search.url" = "http://127.0.0.1/";
              "extensions.getAddons.search.browseURL" = "http://127.0.0.1/";
              "extensions.getAddons.get.url" = "http://127.0.0.1/";
              "extensions.getAddons.link.url" = "http://127.0.0.1/";
              "extensions.getAddons.discovery.api_url" = "http://127.0.0.1/";
              "extensions.systemAddon.update.url" = "";
              "extensions.systemAddon.update.enabled" = false;
              "extensions.getAddons.langpacks.url" = "http://127.0.0.1/";
              "lightweightThemes.getMoreURL" = "http://127.0.0.1/";
              "browser.geolocation.warning.infoURL" = "";
              "browser.xr.warning.infoURL" = "";
              "pfs.datasource.url" = "http://127.0.0.1/";
              "pfs.filehint.url" = "http://127.0.0.1/";
              "media.gmp-manager.url.override" = "data:text/plain,";
              "media.gmp-manager.url" = "";
              "media.gmp-manager.updateEnabled" = false;
              "media.gmp-gmpopenh264.enabled" = false;
              "media.gmp-eme-adobe.enabled" = false;
              "middlemouse.contentLoadURL" = false;
              "browser.selfsupport.url" = "";
              "browser.apps.URL" = "";
              "loop.enabled" = false;
              "browser.user_preferences.inContent" = false;
              "browser.aboutHomeSnippets.updateUrl" = "data:text/html";
              "browser.user_preferences.moreFromMozilla" = false;
              "gfx.direct2d.disabled" = true;
              "browser.casting.enabled" = false;
              "social.directories" = "";
              "security.ssl.errorReporting.enabled" = false;
              "security.tls.unrestricted_rc4_fallback" = false;
              "security.tls.insecure_fallback_hosts.use_static_list" = false;
              "security.tls.version.min" = 1;
              "security.ssl.require_safe_negotiation" = false;
              "security.ssl.treat_unsafe_negotiation_as_broken" = true;
              "security.ssl3.rsa_seed_sha" = true;
              "security.ssl3.dhe_rsa_aes_128_sha" = false;
              "security.ssl3.dhe_rsa_aes_256_sha" = false;
              "security.ssl3.dhe_dss_aes_128_sha" = false;
              "security.ssl3.dhe_rsa_des_ede3_sha" = false;
              "security.ssl3.rsa_des_ede3_sha" = false;
              "browser.pocket.enabled" = false;
              "extensions.pocket.enabled" = false;
              "browser.preferences.moreFromMozilla" = false;
              "extensions.allowPrivateBrowsingByDefault" = true;
              "network.IDN_show_punycode" = true;
              "extensions.screenshots.disabled" = true;
              "browser.onboarding.newtour" = "performance,private,addons,customize,default";
              "browser.onboarding.updatetour" = "performance,library,singlesearch,customize";
              "browser.onboarding.enabled" = false;
              "browser.newtabpage.activity-stream.showTopSites" = false;
              "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
              "browser.newtabpage.activity-stream.feeds.snippets" = false;
              "browser.newtabpage.activity-stream.disableSnippets" = true;
              "browser.newtabpage.activity-stream.tippyTop.service.endpoint" = "";
              "gfx.xrender.enabled" = true;
              "dom.webnotifications.enabled" = false;
              "dom.webnotifications.serviceworker.enabled" = false;
              "dom.push.enabled" = false;
              "browser.newtabpage.activity-stream.asrouter.useruser_prefs.cfr" = false;
              "extensions.htmlaboutaddons.discover.enabled" = false;
              "extensions.htmlaboutaddons.recommendations.enabled" = false;
              "services.settings.server" = "";
              "browser.region.network.scan" = false;
              "browser.contentblocking.report.hide_vpn_banner" = true;
              "browser.contentblocking.report.mobile-ios.url" = "";
              "browser.contentblocking.report.mobile-android.url" = "";
              "browser.contentblocking.report.show_mobile_app" = false;
              "browser.contentblocking.report.vpn.enabled" = false;
              "browser.contentblocking.report.vpn.url" = "";
              "browser.contentblocking.report.vpn-promo.url" = "";
              "browser.contentblocking.report.vpn-android.url" = "";
              "browser.contentblocking.report.vpn-ios.url" = "";
              "browser.privatebrowsing.promoEnabled" = false;
              "browser.region.network.url" = "";
              "dom.security.https_only_mode" = true;
              "dom.security.https_only_mode_send_http_background_request" = false;
              "browser.xul.error_pages.expert_bad_cert" = true;
              "layout.css.font-visibility.private" = 1;
              "layout.css.font-visibility.standard" = 1;
              "layout.css.font-visibility.trackingprotection" = 1;
              "privacy.userContext.enabled" = true;
              "privacy.userContext.ui.enabled" = true;
              "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
              "media.peerconnection.ice.default_address_only" = true;
              "dom.disable_window_move_resize" = true;
              "accessibility.force_disabled" = 1;
              "browser.helperApps.deleteTempFileOnExit" = true;
              "browser.uitour.enabled" = false;
              "devtools.debugger.remote-enabled" = false;
              "webchannel.allowObject.urlWhitelist" = "";
              "permissions.manager.defaultsUrl" = "";
              "pdfjs.enableScripting" = false;
              "permissions.delegation.enabled" = false;
              "browser.contentblocking.category" = "strict";
              "security.tls.version.enable-deprecated" = false;
              "extensions.webcompat.enable_shims" = true;
              "privacy.resistFingerprinting.letterboxing" = true;
              "privacy.window.maxInnerWidth" = 1600;
              "privacy.window.maxInnerHeight" = 900;           
            };
          };
        };
      };
      foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "JetbrainsMono:10";
            dpi-aware = "yes";
          };
          colors = {
            foreground = "f8f8f2";
            background = "212121";

            regular0 = "21222c";
            regular1 = "ff5555";
            regular2 = "50fa7b";
            regular3 = "ffcb6b";
            regular4 = "82aaff";
            regular5 = "c792ea";
            regular6 = "8be9fd";
            regular7 = "f8f8f2";

            bright0 = "545454";
            bright1 = "ff6e6e";
            bright2 = "69ff94";
            bright3 = "ffcb6b";
            bright4 = "d6acff";
            bright5 = "ff92df";
            bright6 = "a4ffff";
            bright7 = "f8f8f2";

            alpha = "0.9";
          };
          mouse.hide_when_typing = "yes";
        };
      };
      git = {
        delta.enable = true;
        enable = true;
        extraConfig = {
          branch.autosetupmerge = "true";
          commit.gpgsign = true;
          config.pull.rebase = false;
          core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
          delta.line-numbers = true;
          gpg.format = "ssh";
          gpg.ssh.allowedsignersfile = "";
          init.defaultBranch = "main";
          merge.stat = "true";
          pull.ff = "only";
          push.default = "current";
          rebase = {
            autoSquash = true;
            autoStash = true;
          };
          repack.usedeltabaseoffset = "true";
          rerere = {
            autoupdate = true;
            autoStash = true;
          };
        };
        lfs.enable = true;
        signing = { 
          key = "~/.ssh/id_ed25519";
          signByDefault = true;
        };
        userName = "17robots";
        userEmail = "mdray@ameritech.net";
      };
      gpg.enable = true;
      home-manager.enable = true;
      kitty = {
        enable = true;
        font = {
          name = "JetbrainsMono";
          size = 10;
        };
        settings = {
          background_opacity = "0.9";
          foreground = "#979eab";
          background = "#282c34";
          cursor = "#cccccc";
          color0 = "#282c34";
          color1 = "#e06c75";
          color2 = "#98c379";
          color3 = "#e5c07b";
          color4 = "#61afef";
          color5 = "#be5046";
          color6 = "#56b6c2";
          color7 = "#979eab";
          color8 = "#393e48";
          color9 = "#d19a66";
          color10 = "#56b6c2";
          color11 = "#e5c07b";
          color12 = "#61afef";
          color13 = "#be5046";
          color14 = "#56b6c2";
          color15 = "#abb2bf";
          selection_foreground = "#282c34";
          selection_background = "#979eab";         
        };
      };
      man.enable = true;
      neovim.enable = true;
      nix-index.enable = true;
      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "bottom";
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
      zoxide.enable = true;
    };
    services = {
      dunst = {
        enable = true;
        settings = {
          global = {
            frame_color = "#f4b8e4";
            separator_color = "#f4b8e4";
            width = 220;
            height = 220;
            offset = "0x15";
            font = "Iosevka 10";
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
      mako.enable = true;
    };
    systemd.user = {
      services = {
        footserver = mkService {
          Unit.Description = "Foot terminal server";
        };
        swaybg = mkService {
          Unit.Description = "Wallpaper Chooser";
          Service = {
            ExecStart = "${lib.getExe pkgs.swaybg} -i ${./hyprland/wall.png}";
            Restart = "always";
          };
        };
      };
    };
    wayland.windowManager.sway = {
      config = {
        gaps = {
          inner = 5;
          outer = 5;
        };
        menu = "bemenu-run";
        modifier = "Mod4";
        terminal = "kitty";
      };
      enable = true;
      extraConfig = ''
        bindsym XF86MonBrightnessDown exec light -U 10
        bindsym XF86MonBrightnessUp exec light -A 10
        bindsym XF86AudioRaiseVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
        bindsym XF86AudioLowerVolume exec 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
        bindsym XF86AudioMute exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
      '';
    };
    xdg.enable = true;
  };
}
