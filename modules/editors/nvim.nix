{ lib, pkgs, config, inputs, ... }: {
  xdg.configFile."nvim".source = inputs.nvim-config.outPath;
  home.sessionVariables = {
    NIX_NEOVIM = 1;
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimDiffAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      astro-language-server
      eslint_d
      gopls
      prettierd
      typescript-language-server
      zls
    ];
  };
}
