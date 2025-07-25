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
    "$pidofBin" = pidofBin;
    "$hyprctlBin" = hyprctlBin;
    "$loginctlBin" = "${systemd}/bin/loginctl";
    "$playerctlBin" = "${playerctl}/bin/playerctl";
    "$hyprlockBin" = hyprlockBin;
    "$brightnessctlBin" = "${brightnessctl}/bin/brightnessctl";
    "$systemctlBin" = systemctlPath;

    general = {
      lock_cmd = "$pidofBin hyprlock || $playerctlBin stop && $hyprlockBin";
      before_sleep_cmd = "$loginctlBin lock-session";
      after_sleep_cmd = "$hyprctlBin dispatch dpms on";
    };

    listener = [
      {
        timeout = 150;
        on-timeout = "$brightnessctlBin -s set 10";
        on-resume = "$brightnessctlBin -r";
      }

      {
        timeout = 150;
        on-timeout = "$brightnessctlBin -sd rgb:kbd_backlight set 0";
        on-resume = "$brightnessctlBin -rd rgb:kbd_backlight";
      }

      {
        timeout = 300;
        on-timeout = "$loginctlBin lock-session";
      }

      {
        timeout = 330;
        on-timeout = "$hyprctlBin dispatch dpms off";
        on-resume = "$hyprctlBin dispatch dpms on";
      }

      {
        timeout = 1800;
        on-timeout = "$systemctlBin suspend";
      }
    ];
  };
}
