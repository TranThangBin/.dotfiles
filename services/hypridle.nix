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
    general = {
      lock_cmd = "${pidofBin} hyprlock || ${playerctl}/bin/playerctl stop && ${hyprlockBin}";
      before_sleep_cmd = "${systemd}/bin/loginctl lock-session";
      after_sleep_cmd = "${hyprctlBin} dispatch dpms on";
    };

    listener = [
      {
        timeout = 150;
        on-timeout = "${brightnessctl}/bin/brightnessctl -s set 10";
        on-resume = "${brightnessctl}/bin/brightnessctl -r";
      }

      {
        timeout = 150;
        on-timeout = "${brightnessctl}/bin/brightnessctl -sd rgb:kbd_backlight set 0";
        on-resume = "${brightnessctl}/bin/brightnessctl -rd rgb:kbd_backlight";
      }

      {
        timeout = 300;
        on-timeout = "${systemd}/bin/loginctl lock-session";
      }

      {
        timeout = 330;
        on-timeout = "${hyprctlBin} dispatch dpms off";
        on-resume = "${hyprctlBin} dispatch dpms on";
      }

      {
        timeout = 1800;
        on-timeout = "${systemctlPath} suspend";
      }
    ];
  };
}
