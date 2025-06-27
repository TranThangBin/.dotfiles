{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar = {
    systemd.enable = true;
    style = ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/player" ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
          "clock"
          "tray"
          "power-profiles-daemon"
          "custom/notification"
        ];
        "hyprland/workspaces" = {
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
        "custom/player" = with config.services; {
          format = " ";
          escape = true;
          interval = 5;
          tooltip = true;
          tooltip-format = "{text}";
          exec = "${playerctld.package}/bin/playerctl metadata --format='{{ title }}'";
          on-click = "${playerctld.package}/bin/playerctl play-pause";
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
          on-click = "${pkgs.uwsm}/bin/uwsm-app ${
            assert lib.pathExists "/usr/bin/tuned-gui";
            "/usr/bin/tuned-gui"
          }";
        };
        pulseaudio = with pkgs; {
          format = "{icon} {volume}% | {format_source}";
          format-muted = "<s>{icon} {volume}%</s> | {format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "<s>󰍬 {volume}%</s>";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "${uwsm}/bin/uwsm-app ${pwvucontrol}/bin/pwvucontrol";
          on-click-middle = "${uwsm}/bin/uwsm-app ${helvum}/bin/helvum";
          on-click-right = "${uwsm}/bin/uwsm-app ${config.services.easyeffects.package}/bin/easyeffects";
        };
        power-profiles-daemon = {
          format-icons = {
            default = "";
            performance = "";
            balanced = "󰗑";
            power-saver = "";
          };
        };
        "custom/notification" = with config.services; {
          format = "{icon}";
          format-icons = {
            notification = "󱅫";
            none = "󰂚";
            dnd-notification = "󰂛";
            dnd-none = "󰂛";
            inhibited-notification = "󱅫";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec = "${swaync.package}/bin/swaync-client -swb";
          on-click = "${swaync.package}/bin/swaync-client -t -sw";
          on-click-right = "${swaync.package}/bin/swaync-client -d -sw";
          escape = true;
        };
      };
    };
  };
}
