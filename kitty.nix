{ config, pkgs, ... }:
{
  home.packages = [ pkgs.imagemagick ];
  programs.kitty = {
    package = config.lib.nixGL.wrap pkgs.kitty;
    shellIntegration.enableZshIntegration = true;
    themeFile = "GitHub_Dark_High_Contrast";
    font = {
      name = "FiraCode Nerd Font Mono";
      package = pkgs.nerd-fonts.fira-code;
      size = 16;
    };
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
    };
  };
}
