{ pkgs, ... }:
let
  utils = import ../utils.nix;
in
{
  xdg.configFile."waybar/style.css" = {
    enable = utils.HYPRLAND_AVAILABLE;
    source = "${./style.css}";
  };

  programs.waybar = {
    enable = utils.HYPRLAND_AVAILABLE;
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
        "custom/music" = {
          format = "  {}";
          escape = true;
          interval = 5;
          tooltip = false;
          exec = "${pkgs.playerctl}/bin/playerctl metadata --format='{{ title }}'";
          on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
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
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "<s>{icon} {volume}%</s>";
          format-icons = {
            default = [
              "󰎉"
              "󰎋"
              "󰎇"
            ];
          };
          on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-middle = "${pkgs.helvum}/bin/helvum";
          on-click-right = "${pkgs.pwvucontrol}/bin/pwvucontrol";
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
