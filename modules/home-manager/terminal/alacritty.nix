{ ... }:
{
  config = {
    programs = {
      alacritty = {
        enable = true;
        settings = {
          colors = {
            bright = {
              black = "#545454";
              blue = "#d6acff";
              cyan = "#a4ffff";
              green = "#69ff94";
              magenta = "#ff92df";
              red = "#ff6e6e";
              white = "#f8f8f2";
              yellow = "#ffcb6b";
            };
            normal = {
              black = "#21222c";
              blue = "#82aaff";
              cyan = "#8be9fd";
              green = "#50fa7b";
              magenta = "#c792ea";
              red = "#ff5555";
              white = "#f8f8f2";
              yellow = "#ffcb6b";
            };
            primary = {
              background = "#212121";
              foreground = "#f8f8f2";
            };
          };
          font = {
            normal = {
              family = "JetbrainsMono";
            };
            size = 10;
          };
        };
      };
    };
  };
}
