{ config, pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
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
}


