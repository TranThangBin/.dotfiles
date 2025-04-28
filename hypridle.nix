let
  pkgsUnstable = import <nixpkgs-unstable> { };
  hyprlockBin = /usr/bin/hyprlock;
  hyprctlBin = /usr/bin/hyprctl;
in
{
  services.hypridle = {
    settings = {
      general = {
        lock_cmd = "pidof ${hyprlockBin} || ${hyprlockBin}";
        before_sleep_cmd = "${pkgsUnstable.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${hyprlockBin} dispatch dpms on";
      };

      listener = with pkgsUnstable; [
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
          on-timeout = "${systemd}/bin/systemctl suspend";
        }
      ];
    };
  };

}
