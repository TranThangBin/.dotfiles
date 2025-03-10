{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    clearDefaultKeybinds = true;
    package = (config.lib.nixGL.wrap pkgs.ghostty);
    settings = {
      theme = "GitHub-Dark-High-Contrast";
      command = "${config.programs.zsh.package}/bin/zsh";
      font-size = 16;
    };
  };
}
