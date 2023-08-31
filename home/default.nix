{ inputs, config, pkgs, lib, ... }:
with lib; let
  inherit (inputs.anyrun.packages.${pkgs.system}) anyrun;
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
  imports = [
    ./programs
    ./wayland/sway
  ];
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
    services = {
      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
        enableSshSupport = true;
      };
    };
    xdg.enable = true;
  };
}
