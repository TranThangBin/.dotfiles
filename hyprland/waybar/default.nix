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
    settings = [
      {
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/player" ];
        modules-right = [
          "tray"
          "power-profiles-daemon"
          "custom/notification"
          "image"
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
        power-profiles-daemon = {
          format-icons = {
            default = "";
            performance = "";
            balanced = "󰗑";
            power-saver = "";
          };
        };
        "custom/player" = with config.services; {
          tooltip-format = "{text}";
          format = "{icon} | {text}";
          format-icons = {
            playing = "";
            paused = "";
          };
          max-length = 50;
          return-type = "json";
          exec = lib.concatStringsSep " " [
            "${playerctld.package}/bin/playerctl"
            "metadata"
            "-F"
            "-f"
            '''{ "text": "{{ markup_escape(title) }}", "alt": "{{ lc(status) }}" }' ''
          ];
          on-click = "${playerctld.package}/bin/playerctl play-pause";
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
        "image" = {
          path = "${./distro.svg}";
          size = 32;
        };
      }

      {
        position = "right";
        modules-right = [
          "pulseaudio#speaker"
          "pulseaudio#microphone"
          "backlight"
          "battery"
          "clock"
        ];
        "pulseaudio#speaker" = with pkgs; {
          format = "{icon} {volume}%";
          format-muted = "<s>{icon} {volume}%</s>";
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
        "pulseaudio#microphone" = {
          format = "{format_source}";
          format-source = "󰍬 {volume}%";
          format-source-muted = "<s>󰍬 {volume}%</s>";

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
            "tuned-gui"
          }";
        };
        clock = {
          timezone = "Asia/Ho_Chi_Minh";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "󰥔 {:%H:%M}";
          format-alt = " {:%a %d}";
        };
      }
    ];
  };
}
