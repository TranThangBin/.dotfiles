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
        position = "right";
        modules-left = [
          "image"
          "custom/notification"
          "power-profiles-daemon"
        ];
        modules-right = [
          "clock"
          "pulseaudio#speaker"
          "pulseaudio#microphone"
          "backlight"
          "battery"
        ];
        image = {
          path = "${./distro.svg}";
          size = 24;
        };
        power-profiles-daemon = {
          format-icons = {
            default = "";
            performance = "";
            balanced = "󰗑";
            power-saver = "";
          };
        };
        clock = {
          timezone = "Asia/Ho_Chi_Minh";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          justify = "center";
          format = "󰥔\n{:%H:%M}";
          format-alt = "\n{:%a %d}";
        };
        "pulseaudio#speaker" = with pkgs; {
          justify = "center";
          format = "{icon}\n{volume}%";
          format-muted = "<s>{icon}\n{volume}%</s>";
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
        "pulseaudio#microphone" = with pkgs; {
          justify = "center";
          format = "{format_source}";
          format-source = "󰍬\n{volume}%";
          format-source-muted = "<s>󰍬\n{volume}%</s>";
          on-scroll-up = "${wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 1%+";
          on-scroll-down = "${wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 1%-";
        };
        backlight = {
          device = "intel_backlight";
          justify = "center";
          format = "{icon}\n{percent}%";
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
          justify = "center";
          format = "{icon}\n{capacity}%";
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
        };
      }

      {
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/player" ];
        modules-right = [ "tray" ];
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
            '''{ "text": "{{ markup_escape(title) }}", "alt": "{{ lc(status) }}", "tooltip": "{{ duration(position) }} / {{duration(mpris:length)}}\n{{ markup_escape(title) }}" }' ''
          ];
          on-click = "${playerctld.package}/bin/playerctl play-pause";
          escape = true;
        };
      }
    ];
  };
}
