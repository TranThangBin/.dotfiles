{ config, pkgs, ... }:
{
  programs.ghostty = {
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    settings = {
      theme = "GitHub-Dark-High-Contrast";
      command = "${pkgs.zsh}/bin/zsh";
      font-family = "FiraCode Nerd Font Mono";
      font-size = 16;
      cursor-opacity = 0.5;
      background-opacity = 0.95;
    };
  };
}
