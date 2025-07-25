{
  settings = {
    "$font_family" = "FiraMono Nerd Font Mono";
    "$hyprlockBg" = "${./hyprlock-Mountain_Sunset.png}";
    "$hyprlockImg" = "${./hyprlock-Go_Gopher.webp}";

    source = [
      "${../hypr/hyprcat.conf}"
      "${../hypr/hyprlock.conf}"
    ];
  };
}
