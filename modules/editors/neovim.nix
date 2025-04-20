{ config, pkgs, inputs,  ... }: {
  xdg.configFile."nvim".source = inputs.nvim-config.outPath;
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      astro-language-server
      eslint_d
      gopls
      prettierd
      svelte-language-server
      typescript-language-server
      zls
    ];
  };
}
