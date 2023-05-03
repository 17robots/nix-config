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
  screenshot = pkgs.weiteShellScriptBin "screenshot" ''
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
  config = {
    home = {
      stateVersion = "22.11";
      packages = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum
        ocrScript
        run-as-service
        screenshot
        volume
        (wrapFirefox firefox-esr-102-unwrapped {
          forceWayland = true;
          CaptivePortal = false;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisableFirefoxAccounts = true;
          DisableFormHistory = true;
          DisaleBookmarksToolbar = true;
          DontCheckDefaultBrowser = true;
          SearchEngines = {
            Add = [
              {
                Name = "Searx";
                Description = "Decentralized Search Engine";
                Alias = "sx";
                Method = "GET";
                URLTemplate = "https://search.unlocked.link/?preferences=eJx1V82SpDYMfppwobYrmz2kcuhTKtkHyOZMCVsNGmyL9U_TzNNHbqAxw-QwVFu25U9_nzQKInbsCcO1Q4ceTGXAdQk6vKL78u8_lWEFJi8qSJEV29FgxGvH3BmsyMrJZvT8mK8_fMLKYuxZX7__9aMKcMOA4FV__bWKPVq8BsrXK48hmRgado3DqYnQXv8GE7DSTI1ssrmjvzLI8sK-q5ZrTYizIMkwKoUuom_AUOes_F7vg76DU6ib9d1F-jOhnxtyTaQoChYhuRs5iqJVeTZmA0ABWiMK0HXkxCt_dNA1TWBFYGqLmuCX3_6Ecagtec--aW5kMDxlArGWbx0ieyw2BAjdsabQNKuPRdqS647r2CY1YGwairJWSn2J96a5k0bOanhEJ14Jovnp9CwT5CF4vAlARSiGi2zGsdSrkjeEpUQjvovrGpsCqbzWXa3x6QxidwCJnifSTcMSPS_riQbSEOGgTlDnv44_l9YL2gJ1sTchZNX7C4sXLYxyQb4Zg-U3GrPj91NfH4W6m_acQW7-vnnEOvAtTuCx1uRRSUDm1a83T24gUIWCjjqJOYRYGtBJqkC7BYM1tui7dbnkfj0amHPAw_52uWP5TtnuVwS7kbUuPd9D6yF_Vr1kdbsbSQ6Ky-TkJ3EKn8s2lW8Uet51DKQGCAVAQ_Kkn-tsaKByg9sQ8eLDigXezexJFaod4v0QeTfa9bCbAXZVOVM9jlxoH0FwdBS27B5Te9F4X1dLsWYn1_nzihRYyHjxdcyCi6TqoHo24MusDxF8HDMXFQAjDzNHFo8M4HYwcaKYyeNjVc_Q8yGJJ2rncm3BCykIpoMbhB0f4LQ_SnOptMxD-CgUwhNZ_q6Cn4kjfjwVOHl1kub6pzifxDx_sPzrt2-_P3aLddLo9qwI-O7AHizjN8ThEFy4ZxftAp_auUO75ceI6GNqsUjHpx_liUHyfpqwLbZ8ssKqhWDiBw3sJAnqMDt2s8UC39t4GSd35B0rBHUgTC8IS8GIMVN4TqX_EZ-pqNw8BEbybq-FJRh9emZvhe7YIZ6XDbn0qDPOrX68ZGrxEvgH3cuMbSVnFNhxL7B8eyW6Y584435KD4CfksW9hZvbqKnr9kSQbuDl_fnYD-4kdSWAS45m6UW-7tNGgVFsnQ_-xjhbdmJ4EbmbEcLxJbeio5KfZB1zkS08SnF_YKHOAwUvZHoyfpUfzF9lJwes8k8Yo1_fez7-_mUlxjNT8k1IyXUylZQYxOzuyIaWHspw0rutwlYD4UbumRVBmlHunwFl-CmwbHtCi-JAWPvwcT9E6WtReuLWGEedq28_NPbCde61S15GuxYKi0S7lOjhyjxu-fpzkhwo7XkKjk5eRKd4LOKT68VUTfHEsgFHgq1MX4elxKQcjv4TTlcDCw3dDE9bWYUhtcnFtJVmGtGn8PKyjI6kpd1Llsei_yQXpCeHvkD9ZPujfTOnD5T2kryGJSAjaZ8jVBy7k0Uu2Y2GfOKZTy8OY7N0tLEvJhlNKr6zO-S9FTK0MrHU0YMLRsJYjmDstaOhEMToL7SR5T7AjiYJP4VrdvXjsq4uRng0rk2glAc0N5mQb3zaEWc2qkc1vIjvc819du-yOOnoOUTpOCizvYRhadiHAwzNMvpPXuB9gu6ZLuJztfy_MsuAb2SuO6P1kImrkalXtNmcPaczEq1GamXAOVQyIkhpXf8DAvvsTg==&q={searchTerms}";
              }
            ];
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
          PromptForDownloadLocation = false;
          UserMessaging = {
            ExtensionRecommendations = false;
            SkipOnboarding = true;
          };
          SanitizeOnShutdown = {
            Cache = true;
            History = true;
            Cookies = false;
            Downloads = true;
            FormData = true;
            Sessions = true;
            OfflineApps = true;
          };
          Preferences = {
            "browser.toolbars.bookmarks.visibility" = "never";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "toolkit.zoomManager.zoomValues" = ".8,.90,.95,1.1.1,1.2";
            "browser.uidensity" = 1;
            "general.useragent.override" = "";
            "browser.uiCustomization.state" = ''
              {"placements":{"widget-overflow-fixed-list":["nixos_ublock-origin-browser-action","nixos_sponsorblock-browser-action","nixos_temporary-containers-browser-action","nixos_ublock-browser-action","nixos_ether_metamask-browser-action","nixos_cookie-autodelete-browser-action","screenshot-button","panic-button","nixos_localcdn-fork-of-decentraleyes-browser-action","nixos_sponsor-block-browser-action","nixos_image-search-browser-action","nixos_webarchive-browser-action","nixos_darkreader-browser-action","bookmarks-menu-button","nixos_df-yt-browser-action","nixos_i-hate-usa-browser-action","nixos_qr-browser-action","nixos_proxy-switcher-browser-action","nixos_port-authority-browser-action","sponsorblocker_ajay_app-browser-action","jid1-om7ejgwa1u8akg_jetpack-browser-action","dontfuckwithpaste_raim_ist-browser-action","ryan_unstoppabledomains_com-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","_36bdf805-c6f2-4f41-94d2-9b646342c1dc_-browser-action","_ffd50a6d-1702-4d87-83c3-ec468f67de6a_-browser-action","addon_darkreader_org-browser-action","cookieautodelete_kennydo_com-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action","skipredirect_sblask-browser-action","ublock0_raymondhill_net-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","fxa-toolbar-menu-button","nixos_absolute-copy-browser-action","webextension_metamask_io-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button","_c607c8df-14a7-4f28-894f-29e8722976af_-browser-action"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","nixos_sponsorblock-browser-action","nixos_clearurls-browser-action","nixos_cookie-autodelete-browser-action","nixos_ether_metamask-browser-action","nixos_ublock-origin-browser-action","nixos_localcdn-fork-of-decentraleyes-browser-action","nixos_vimium-browser-action","nixos_copy-plaintext-browser-action","nixos_h264ify-browser-action","nixos_fastforwardteam-browser-action","nixos_single-file-browser-action","treestyletab_piro_sakura_ne_jp-browser-action","nixos_don-t-fuck-with-paste-browser-action","nixos_temporary-containers-browser-action","nixos_absolute-copy-browser-action","nixos_image-search-browser-action","nixos_webarchive-browser-action","nixos_unstoppable-browser-action","nixos_dontcare-browser-action","nixos_skipredirect-browser-action","nixos_ublock-browser-action","nixos_darkreader-browser-action","nixos_fb-container-browser-action","nixos_vimium-ff-browser-action","nixos_df-yt-browser-action","nixos_sponsor-block-browser-action","nixos_proxy-switcher-browser-action","nixos_port-authority-browser-action","nixos_i-hate-usa-browser-action","nixos_qr-browser-action","dontfuckwithpaste_raim_ist-browser-action","jid1-om7ejgwa1u8akg_jetpack-browser-action","ryan_unstoppabledomains_com-browser-action","_36bdf805-c6f2-4f41-94d2-9b646342c1dc_-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","_ffd50a6d-1702-4d87-83c3-ec468f67de6a_-browser-action","7esoorv3_alefvanoon_anonaddy_me-browser-action","addon_darkreader_org-browser-action","cookieautodelete_kennydo_com-browser-action","skipredirect_sblask-browser-action","ublock0_raymondhill_net-browser-action","_531906d3-e22f-4a6c-a102-8057b88a1a63_-browser-action","webextension_metamask_io-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","_b86e4813-687a-43e6-ab65-0bde4ab75758_-browser-action","_c607c8df-14a7-4f28-894f-29e8722976af_-browser-action","sponsorblocker_ajay_app-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":17,"newElementCount":29}
            '';
            "browser.aboutConfig.showWarning" = false;
            "browser.shell.checkDefaultBrowser" = false;
            "browser.startup.page" = 1;
            "browser.newtabpage.enabled" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "geo.provider.use_corelocation" = false;
            "geo.provider.use_gpsd" = false;
            "geo.provider.use_geoclue" = false;
            "geo.enabled" = false;
            "browser.region.network.url" = "";
            "browser.region.update.enabled" = false;
            "intl.accept_languages" = "en-US = en";
            "javascript.use_us_english_locale" = true;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data: =";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";
            "browser.ping-centre.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "captivedetect.canonicalURL" = "";
            "network.captive-portal-service.enabled" = false;
            "network.connectivity-service.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "network.prefetch-next" = false;
            "network.dns.disablePrefetch" = true;
            "network.predictor.enabled" = false;
            "network.predictor.enable-prefetch" = false;
            "network.http.speculative-parallel-limit" = 0;
            "browser.places.speculativeConnect.enabled" = false;
            "network.dns.disableIPv6" = true;
            "network.proxy.socks_remote_dns" = true;
            "network.file.disable_unc_paths" = true;
            "network.gio.supported-protocols" = "";
            "keyword.enabled" = true;
            "browser.fixup.alternate.enabled" = false;
            "browser.search.suggest.enabled" = false;
            "browser.urlbar.suggest.searches" = false;
            "browser.urlbar.speculativeConnect.enabled" = false;
            "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.formfill.enable" = false;
            "signon.autofillForms" = false;
            "signon.formlessCapture.enabled" = false;
            "network.auth.subresource-http-auth-allow" = 1;
            "browser.cache.disk.enable" = false;
            "browser.privatebrowsing.forceMediaMemoryCache" = true;
            "media.memory_cache_max_size" = 65536;
            "browser.sessionstore.privacy_level" = 2;
            "toolkit.winRegisterApplicationRestart" = false;
            "browser.shell.shortcutFavicons" = false;
            "security.ssl.require_safe_negotiation" = true;
            "security.tls.enable_0rtt_data" = false;
            "security.OCSP.enabled" = 1;
            "security.OCSP.require" = true;
            "security.family_safety.mode" = 0;
            "security.cert_pinning.enforcement_level" = 2;
            "security.remote_settings.crlite_filters.enabled" = true;
            "security.pki.crlite_mode" = 2;
            "security.mixed_content.block_display_content" = true;
            "dom.security.https_only_mode" = true;
            "dom.security.https_only_mode_send_http_background_request" = false;
            "security.ssl.treat_unsafe_negotiation_as_broken" = true;
            "browser.ssl_override_behavior" = 1;
            "browser.xul.error_pages.expert_bad_cert" = true;
            "network.http.referer.XOriginPolicy" = 0;
            "network.http.referer.XOriginTrimmingPolicy" = 2;
            "privacy.userContext.enabled" = true;
            "privacy.userContext.ui.enabled" = true;
            "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
            "media.peerconnection.ice.default_address_only" = true;
            "media.eme.enabled" = true;
            "dom.disable_beforeunload" = true;
            "dom.disable_window_move_resize" = true;
            "dom.disable_open_during_load" = true;
            "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";
            "accessibility.force_disabled" = 1;
            "beacon.enabled" = false;
            "browser.helperApps.deleteTempFileOnExit" = true;
            "browser.pagethumbnails.capturing_disabled" = true;
            "browser.uitour.enabled" = false;
            "browser.uitour.url" = "";
            "devtools.chrome.enabled" = false;
            "devtools.debugger.remote-enabled" = false;
            "middlemouse.contentLoadURL" = false;
            "permissions.manager.defaultsUrl" = "";
            "webchannel.allowObject.urlWhitelist" = "";
            "network.IDN_show_punycode" = true;
            "pdfjs.disabled" = false;
            "pdfjs.enableScripting" = false;
            "network.protocol-handler.external.ms-windows-store" = false;
            "permissions.delegation.enabled" = false;
            "browser.download.useDownloadDir" = false;
            "browser.download.alwaysOpenPanel" = false;
            "browser.download.manager.addToRecentDocs" = false;
            "browser.download.always_ask_before_handling_new_types" = true;
            "extensions.enabledScopes" = 5;
            "extensions.autoDisableScopes" = 15;
            "extensions.postDownloadThirdPartyPrompt" = false;
            "browser.contentblocking.category" = "strict";
            "privacy.partition.serviceWorkers" = true;
            "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
            "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;
            "privacy.cpd.cache" = true;
            "privacy.cpd.formdata" = true;
            "privacy.cpd.history" = true;
            "privacy.cpd.sessions" = true;
            "privacy.cpd.offlineApps" = false;
            "privacy.cpd.cookies" = false;
            "privacy.resistFingerprinting" = true;
            "privacy.window.maxInnerWidth" = 1600;
            "privacy.window.maxInnerHeight" = 900;
            "privacy.resistFingerprinting.block_mozAddonManager" = true;
            "privacy.resistFingerprinting.letterboxing" = true;
            "browser.startup.blankWindow" = false;
            "browser.display.use_system_colors" = false;
            "widget.non-native-theme.enabled" = true;
            "browser.link.open_newwindow" = 3;
            "browser.link.open_newwindow.restriction" = 0;
            "webgl.disabled" = false;
            "extensions.blocklist.enabled" = true;
            "network.http.referer.spoofSource" = false;
            "security.dialog_enable_delay" = 1000;
            "privacy.firstparty.isolate" = false;
            "extensions.webcompat.enable_shims" = true;
            "security.tls.version.enable-deprecated" = false;
            "extensions.webcompat-reporter.enabled" = false;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.messaging-system.whatsNewPanel.enabled" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
            "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
            "browser.urlbar.suggest.quicksuggest" = false;
            "app.update.background.scheduling.enabled" = false;
            "security.csp.enable" = true;
            "security.ask_for_password" = 2;
            "security.password_lifetime" = 5;
            "dom.storage.next_gen" = true;
            "network.cookie.lifetimePolicy" = 0;
            "security.pki.sha1_enforcement_level" = 1;
          };
        })
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
    };
    programs = {
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
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          src = pkgs.fetchFromGitHub {
            owner = "Alexays";
            repo = "Waybar";
            rev = "afa590f781c85a95c45138727510244b66ca674c";
            sha256 = "R8/X+mTDAMyFUp6czi6+afD+IP1MAu6xw+ysSEb/r8w=";
          };
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
          patchPhase = ''
            substituteInPlace src/modules/wlr/workspace_manager.cpp --replace "zext_workspace_handle_v1_activate(workspace_handle);" "const std::string command = \"hyprctl dispatch workspace \" + name_; system(command.c_str());"
          '';
        });
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
    services = {
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
    systemd.user = {
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
      targets.tray = {
        Unit = {
          Description = "Home Manager System Tray";
          Requires = ["graphical-session-pre.target"];
        };
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      systemdIntegration = true;
      extraConfig = builtins.readFile ./hyprland/hyprland.conf;
    };
  };
  imports = [
    inputs.hyprland.homeManagerModules.default
    inputs.nix-index-db.hmModules.nix-index
  ];
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
