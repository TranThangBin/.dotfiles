{ config, pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    package = (config.lib.nixGL.wrap pkgs.ghostty);
    settings = {
      theme = "GitHub-Dark-High-Contrast";
      font-family = "FiraMono Nerd Font Mono";
      font-family-bold = "FiraMono Nerd Font Mono Bold";
      font-size = 16;
    };
  };
}
