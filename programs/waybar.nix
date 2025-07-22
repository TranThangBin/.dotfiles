{
  uwsm,
  pwvucontrol,
  helvum,
  easyeffects,
  btop,
  wofiUwsmWrapped,
  kitty,
  ghostty,
  yazi,
  neovide,
  firefox,
  brave,
  swaync,
  hyprsysteminfo,
  wlogout,
  wireplumber,
  ncdu,
  playerctl,
}:
let
  pulseaudioMenu = {
    menu = "on-click-right";
    menu-file = "${./waybar-audio-apps.xml}";
    menu-actions = {
      pwvucontrol = "${uwsm}/bin/uwsm-app ${pwvucontrol}/bin/pwvucontrol &>/dev/null & disown";
      helvum = "${uwsm}/bin/uwsm-app ${helvum}/bin/helvum &>/dev/null & disown";
      easyeffects = "${uwsm}/bin/uwsm-app ${easyeffects}/bin/easyeffects &>/dev/null & disown";
    };
  };
  resourcesModule = {
    on-click = "${uwsm}/bin/uwsm-app ${btop}/share/applications/btop.desktop";
    states = {
      warning = 60;
      critical = 80;
    };
  };
  diskModule = {
    format = "<big></big>:{path} {percentage_used}%";
    tooltip-format = "{specific_used:0.2f} GiB / {specific_total:0.2f} GiB";
    unit = "GB";
    inherit (resourcesModule) states;
  };
in
{
  systemd.enable = true;
  style = ''
    @import url("${../catpuccin-mocha.css}");
    @import url("${./waybar.css}");
  '';
  settings = [
    {
      layer = "top";
      position = "right";
      modules-left = [
        "custom/menu"
        "custom/notification"
        "power-profiles-daemon"
      ];
      modules-center = [
        "clock"
        "pulseaudio#speaker"
        "pulseaudio#microphone"
        "backlight"
      ];
      modules-right = [
        "battery"
        "memory"
        "cpu"
      ];
      "custom/menu" = {
        format = "<big>󰣇</big>";
        tooltip-format = "Left click to open the apps menu\nRight click for more options";
        on-click = "${wofiUwsmWrapped}";
        menu = "on-click-right";
        menu-file = "${./waybar-user-menu.xml}";
        menu-actions = {
          kitty = "${uwsm}/bin/uwsm-app ${kitty}/bin/kitty &>/dev/null & disown";
          ghostty = "${uwsm}/bin/uwsm-app ${ghostty}/bin/ghostty &>/dev/null & disown";
          btop = "${uwsm}/bin/uwsm-app ${btop}/share/applications/btop.desktop &>/dev/null & disown";
          yazi = "${uwsm}/bin/uwsm-app ${yazi}/share/applications/yazi.desktop &>/dev/null & disown";
          neovide = "${uwsm}/bin/uwsm-app ${neovide}/bin/neovide &>/dev/null & disown";
          firefox = "${uwsm}/bin/uwsm-app ${firefox}/bin/firefox &>/dev/null & disown";
          brave = "${uwsm}/bin/uwsm-app ${brave}/bin/brave &>/dev/null & disown";
          swaync = "${swaync}/bin/swaync-client -t -sw";
          hyprsysteminfo = "${uwsm}/bin/uwsm-app ${hyprsysteminfo}/bin/hyprsysteminfo &>/dev/null & disown";
          wlogout = "${wlogout}/bin/wlogout &>/dev/null & disown";
        };
      };
      power-profiles-daemon = {
        format = "<big>{icon}</big>";
        format-icons = {
          default = "";
          performance = "";
          balanced = "󰗑";
          power-saver = "";
        };
      };
      clock = {
        timezone = "Asia/Ho_Chi_Minh";
        tooltip-format = "<big><u>{:%a %d-%m-%Y\n%Z %H:%M}</u></big>\n<small>{calendar}</small>";
        justify = "center";
        format = "<big>󰥔</big>\n{:%I:%M\n%p}";
        format-alt = "<big></big>\n{:%d/%m\n%Y}";
        calendar = {
          mode-mon-col = 3;
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };
      "pulseaudio#speaker" = {
        justify = "center";
        format = "<big>{icon}</big>\n{volume}%";
        format-muted = "<s>{icon}\n{volume}%</s>";
        format-icons = {
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        inherit (pulseaudioMenu) menu menu-file menu-actions;
      };
      "pulseaudio#microphone" = {
        justify = "center";
        format = "{format_source}";
        format-source = "<big>󰍬</big>\n{volume}%";
        format-source-muted = "<s><big>󰍬</big>\n{volume}%</s>";
        on-click = "${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        on-scroll-up = "${wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SOURCE@ 1%+";
        on-scroll-down = "${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-";
        inherit (pulseaudioMenu) menu menu-file menu-actions;
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
        format = "<big>{icon}</big>\n{capacity}%";
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
        on-click = "${uwsm}/bin/uwsm-app ${
          assert builtins.pathExists "/usr/bin/tuned-gui";
          "tuned-gui"
        }";
      };
      memory = {
        format = "<big></big>\n{percentage}%";
        tooltip-format = "{used:0.1f} GiB / {total:0.1f} GiB";
        justify = "center";
        inherit (resourcesModule) states on-click;
      };
      cpu = {
        format = "<big></big>\n{usage}%";
        justify = "center";
        inherit (resourcesModule) states on-click;
      };
      "custom/notification" = {
        format = "<big>{icon}</big>";
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
        exec = "${swaync}/bin/swaync-client -swb";
        on-click = "${swaync}/bin/swaync-client -t -sw";
        on-click-right = "${swaync}/bin/swaync-client -d -sw";
      };
    }

    {
      layer = "top";
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [ "custom/player" ];
      modules-right = [
        "disk#root"
        "disk#home"
        "tray"
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
      "hyprland/window" = {
        icon = true;
        rewrite = {
          "" = "🐧";
        };
      };
      "disk#root" = diskModule // {
        on-click = "${uwsm}/bin/uwsm-app ${ncdu}/share/applications/ncdu.desktop /";
      };
      "disk#home" = diskModule // {
        path = "/home";
        on-click = "${uwsm}/bin/uwsm-app ${ncdu}/share/applications/ncdu.desktop";
      };
      tray = {
        icon-size = 21;
        spacing = 10;
      };
      "custom/player" = {
        format = "<big>{icon}</big> | {text}";
        format-icons = {
          playing = "";
          paused = "";
        };
        max-length = 50;
        return-type = "json";
        exec = builtins.concatStringsSep " " [
          "${playerctl}/bin/playerctl"
          "metadata"
          "-F"
          "-f"
          '''{ "text": "{{ markup_escape(title) }}", "alt": "{{ lc(status) }}", "tooltip": "{{ duration(position) }} / {{duration(mpris:length)}}\n{{ markup_escape(title) }}" }' ''
        ];
        on-click = "${playerctl}/bin/playerctl play-pause";
        escape = true;
      };
    }
  ];
}
