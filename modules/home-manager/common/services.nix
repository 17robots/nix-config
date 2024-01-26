{ ... }:
{
  config = {
    services = {
      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
        enableSshSupport = true;
      };
    };
  };
}

