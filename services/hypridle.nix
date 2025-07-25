{
  pidofBin,
  hyprlockBin,
  systemd,
  hyprctlBin,
  systemctlPath,
  brightnessctl,
  playerctl,
}:
{
  settings = {
    "$hyprctlBin" = hyprctlBin;
    "$loginctlBin" = "${systemd}/bin/loginctl";
    "$playerctlBin" = "${playerctl}/bin/playerctl";
    "$hyprlockBin" = hyprlockBin;
    "$brightnessctlBin" = "${brightnessctl}/bin/brightnessctl";
    "$systemctlBin" = systemctlPath;

    source = "${../hypr/hypridle.conf}";
  };
}
