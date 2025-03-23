{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/music" ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
          "tray"
          "custom/lock"
          "custom/power"
        ];
        "hyprland/workspaces" = {
          disable-scroll = true;
          sort-by-name = true;
          format = " <big>{icon}</big> ";
          format-icons = {
            "1" = "󰲠";
            "2" = "󰲢";
            "3" = "󰲤";
            "4" = "󰲦";
            "5" = "󰲨";
            "6" = "󰲪";
            "7" = "󰲬";
            "8" = "󰲮";
            "9" = "󰲰";
            "10" = "󰿬";
          };
        };
        tray = {
          icon-size = 21;
          spacing = 10;
        };
        "custom/music" = with pkgs; {
          format = "  {}";
          escape = true;
          interval = 5;
          tooltip = false;
          exec = "${playerctl}/bin/playerctl metadata --format='{{ title }}'";
          on-click = "${playerctl}/bin/playerctl play-pause";
          max-length = 50;
        };
        clock = {
          timezone = "Asia/Ho_Chi_Minh";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = " {:%d/%m/%Y}";
          format = "󰥔 {:%H:%M}";
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = {
            default = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            warning = "󰂑";
            critical = "󰂃";
            charging = "󰂄";
            plugged = "";
          };
        };
        pulseaudio = with pkgs; {
          format = "{icon} {volume}%";
          format-muted = "<s>{icon} {volume}%</s>";
          format-icons = {
            default = [
              "󰎉"
              "󰎋"
              "󰎇"
            ];
          };
          on-click = "${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-middle = "${helvum}/bin/helvum";
          on-click-right = "${pwvucontrol}/bin/pwvucontrol";
        };
        "custom/lock" = {
          tooltip = false;
          on-click = "sh -c '(sleep 0.5s; hyprlock)' & disown";
          format = "";
        };
        "custom/power" = {
          tooltip = false;
          on-click = "${pkgs.wlogout}/bin/wlogout &";
          format = "";
        };
      };
    };
  };
}
