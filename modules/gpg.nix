{ config, pkgs, ... }: let
  pinentryPkg = if pkgs.stdenv.isLinux then pkgs.pinentry-tty else pkgs.pinentry-mac;
in {
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "";
      no-emit-version = true;
      keyid-format = "0xlong";
      with-fingerprint = true;
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      use-agent = true;
      charset = "utf-8";
      fixed-list-mode = true;
      personal-cipher-preferences = "AES256 AES192 AES CAST5";
      personal-digest-preferences = "SHA512 SHA384 SHA256 SHA224";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      stk-digest-algo = "SHA512";
      default-preference-list = "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
    };
    scdaemonSettings.disable-ccid = true;
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPkgs = pinentryPkg;
    defaultCacheTtl = 60;
    maxCacheTtl = 60;
    enableBashIntegration = true;
    verbose = true;
  };
}
