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
    ./browser/firefox.nix
    ./terminal/kitty.nix
    ./wayland
    ./wayland/wm/sway.nix
    ./cli.nix
    ./git.nix
    ./gtk.nix
    ./services.nix
  ];
  config = {
    home = {
      packages = with pkgs;
      [
        run-as-service
        graphite-cli
      ];
      sessionVariables = {
        XCURSOR_SIZE = "8";
      };
      stateVersion = "22.11";
    };
    xdg.enable = true;
  };
}

