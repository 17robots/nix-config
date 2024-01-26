{ ... }:
{
  config = {
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
      eza.enable = true;
      fzf.enable = true;
      gh.enable = true;
      gpg.enable = true;
      home-manager.enable = true;
      jq.enable = true;
      man.enable = true;
      neovim.enable = true;
      nix-index.enable = true;
      ripgrep.enable = true;
      starship.enable = true;
    };
  };
}

