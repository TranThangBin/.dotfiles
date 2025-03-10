{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.kitty);
    shellIntegration.enableZshIntegration = true;
    themeFile = "GitHub_Dark_High_Contrast";
    font = {
      name = "FiraMono Nerd Font Mono";
      size = 16;
    };
    settings = {
      shell = "${config.programs.zsh.package}/bin/zsh";
    };
  };
}
