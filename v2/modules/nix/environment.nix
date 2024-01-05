{ config, inputs, pkgs, ... }:
{
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
}
