{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.kitty);
    font = {
      name = "FiraMono Nerd Font Mono";
      size = 16;
    };
    themeFile = "GitHub_Dark_High_Contrast";
  };
}
