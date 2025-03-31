let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  home.packages = [ pkgsUnstable.imagemagick ];
  programs.kitty = {
    shellIntegration.enableZshIntegration = true;
    themeFile = "GitHub_Dark_High_Contrast";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 16;
    };
    settings = {
      shell = "${pkgsUnstable.zsh}/bin/zsh";
    };
  };
}
