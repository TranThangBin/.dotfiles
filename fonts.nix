{ pkgs, ... }:
{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.fira-code

    corefonts
  ];
  fonts.fontconfig.defaultFonts = {
    emoji = [ "Noto Color Emoji" ];
    serif = [
      "Noto Serif"
      "Noto Serif CJK JP"
      "Noto Serif CJK HK"
      "Noto Serif CJK KR"
      "Noto Serif CJK SC"
      "Noto Serif CJK TC"
    ];
    sansSerif = [
      "Noto Sans"
      "Noto Sans CJK JP"
      "Noto Sans CJK HK"
      "Noto Sans CJK KR"
      "Noto Sans CJK SC"
      "Noto Sans CJK TC"
    ];
    monospace = [
      "Noto Sans Mono"
      "Noto Sans Mono CJK JP"
      "Noto Sans Mono CJK HK"
      "Noto Sans Mono CJK KR"
      "Noto Sans Mono CJK SC"
      "Noto Sans Mono CJK TC"

      "FiraCode Nerd Font Mono"
    ];
  };
}
