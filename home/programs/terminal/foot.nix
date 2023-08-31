{ inputs, config, pkgs, lib, ... }:
with lib; let
  inherit (inputs.anyrun.packages.${pkgs.system}) anyrun;
  mkService = lib.recursiveUpdate {
    Unit.After = ["graphical-session.target"];
    Unit.PartOf = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  config = {
    programs = {
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
    };
    systemd.user = {
      services = {
        footserver = mkService {
          Unit.Description = "Foot terminal server";
        };
      };
    };
  };
}

