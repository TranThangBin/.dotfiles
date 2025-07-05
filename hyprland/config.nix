{
  config,
  lib,
  pkgs,
  ...
}:
let
  mainMod = "SUPER";

  scripts = config.lib.scripts;
  uwsm = config.lib.packages.uwsm;
  hyprshot = config.lib.packages.hyprshot;

  kitty = config.programs.kitty;
  ghostty = config.programs.ghostty;
  wlogout = config.programs.wlogout;
  yazi = config.programs.yazi;
  btop = config.programs.btop;

  pidof = "${pkgs.toybox}/bin/pidof";
  cmdPrefix = "(${pidof} wlogout || ${pidof} hyprpicker || ${pidof} wofi || ${pidof} slurp)";

  settings = {
    terminal = {
      kitty = "${kitty.package}/bin/kitty";
      ghostty = "${ghostty.package}/bin/ghostty";
    };
    logoutMenu = "${cmdPrefix} || ${wlogout.package}/bin/wlogout";
    colorPicker = "${cmdPrefix} || ${config.lib.packages.hyprpicker}/bin/hyprpicker -a";
    emojiPicker = "${cmdPrefix} || ${config.lib.packages.wofi-emoji}/bin/wofi-emoji";
    launcher = "${cmdPrefix} || ${scripts.wofiUwsmWrapped}";
    fileManager = "${yazi.package}/share/applications/yazi.desktop";
    resourceMonitor = "${btop.package}/share/applications/btop.desktop";
    clipboard = {
      picker = "${cmdPrefix} || ${scripts.clipboardPicker}";
      delete = "${cmdPrefix} || ${scripts.clipboardDelete}";
      wipe = "${cmdPrefix} || ${scripts.clipboardWipe}";
    };
    screenshot = {
      save = {
        region = "${cmdPrefix} || ${hyprshot}/bin/hyprshot -m region";
        window = "${cmdPrefix} || ${hyprshot}/bin/hyprshot -m window";
        output = "${cmdPrefix} || ${hyprshot}/bin/hyprshot -m output";
      };
      clipboard = {
        region = "${cmdPrefix} || ${hyprshot}/bin/hyprshot -m region --clipboard-only";
        window = "${cmdPrefix} || ${hyprshot}/bin/hyprshot -m window --clipboard-only";
        output = "${cmdPrefix} || ${hyprshot}/bin/hyprshot -m output --clipboard-only";
      };
    };
  };

  flamingo = "rgb(f2cdcd)";
  pink = "rgb(f5c2e7)";
  surface0 = "rgb(313244)";

in
{
  wayland.windowManager.hyprland = {
    systemd.enable = false;
    settings = {
      animations = {
        enabled = true;
        animation = "workspaces, 1, 8, default, fade";
      };
      gestures.workspace_swipe = false;
      master.new_status = "master";

      monitor = [
        ",preferred,auto,1"
        "HDMI-A-1,1920x1080,auto,1,mirror,eDP-2"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
        "col.active_border" = pink;
        "col.inactive_border" = surface0;
        "col.nogroup_border_active" = flamingo;
        "col.nogroup_border" = surface0;
      };

      decoration = {
        rounding = 5;
        active_opacity = 1.0;
        inactive_opacity = 0.9;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
        shadow = {
          color = surface0;
          color_inactive = surface0;
        };
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 2;
        touchpad.natural_scroll = false;
      };

      bind =
        [
          "${mainMod}, Return, exec, ${uwsm}/bin/uwsm-app ${settings.terminal.ghostty}"
          "${mainMod}, R, exec, ${uwsm}/bin/uwsm-app ${settings.resourceMonitor}"
          "${mainMod}, E, exec, ${uwsm}/bin/uwsm-app ${settings.fileManager}"
          "${mainMod}, Space, exec, ${settings.launcher}"
          "${mainMod} SHIFT, E, exec, ${settings.logoutMenu}"
          "${mainMod}, C, exec, ${settings.colorPicker}"
          "${mainMod} SHIFT, Space, exec, ${settings.emojiPicker}"

          "${mainMod}, V, exec, ${settings.clipboard.picker}"
          "${mainMod} SHIFT, V, exec, ${settings.clipboard.delete}"
          "${mainMod} CTRL SHIFT, V, exec, ${settings.clipboard.wipe}"

          "${mainMod}, PRINT, exec, ${settings.screenshot.save.region}"
          "${mainMod} SHIFT, PRINT, exec, ${settings.screenshot.save.window}"
          "${mainMod} CTRL SHIFT, PRINT, exec, ${settings.screenshot.save.output}"

          ",PRINT, exec, ${settings.screenshot.clipboard.region}"
          "SHIFT, PRINT, exec, ${settings.screenshot.clipboard.window}"
          "CTRL SHIFT, PRINT, exec, ${settings.screenshot.clipboard.output}"
        ]
        ++ [
          "${mainMod}, code:23, exec, ${pkgs.toybox}/bin/pkill -SIGUSR1 waybar"
          "${mainMod} SHIFT, Q, killactive,"
          "${mainMod}, F, fullscreen,"
          "${mainMod} SHIFT, F, togglefloating,"
          "${mainMod}, P, pseudo,"
          "${mainMod} CTRL SHIFT, J, togglesplit,"

          "${mainMod}, M, togglespecialworkspace, magic"
          "${mainMod} SHIFT, M, movetoworkspace, special:magic"

          "${mainMod}, L, movefocus, r"
          "${mainMod} SHIFT, L, movewindow, r"

          "${mainMod}, H, movefocus, l"
          "${mainMod} SHIFT, H, movewindow, l"

          "${mainMod}, K, movefocus, u"
          "${mainMod} SHIFT, K, movewindow, u"

          "${mainMod}, J, movefocus, d"
          "${mainMod} SHIFT, J, movewindow, d"
        ]
        ++ lib.concatLists (
          [
            [
              "${mainMod}, code:35, workspace, e+1"
              "${mainMod} SHIFT, code:35, movetoworkspace, e+1"
            ]
            [
              "${mainMod}, code:34, workspace, e-1"
              "${mainMod} SHIFT, code:34, movetoworkspace, e-1"
            ]
          ]
          ++ lib.genList (i: [
            "${mainMod}, code:1${toString i}, workspace, ${toString (i + 1)}"
            "${mainMod} SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
          ]) 10
        );

      binde = [
        "${mainMod} CTRL, L, resizeactive, 10 0"
        "${mainMod} CTRL, H, resizeactive, -10 0"
        "${mainMod} CTRL, K, resizeactive, 0 -10"
        "${mainMod} CTRL, J, resizeactive, 0 10"
      ];

      bindl = with config.services; [
        ", XF86AudioNext, exec, ${playerctld.package}/bin/playerctl next"
        ", XF86AudioPause, exec,${playerctld.package}/bin/playerctl play-pause"
        ", XF86AudioPlay, exec, ${playerctld.package}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${playerctld.package}/bin/playerctl previous"
      ];

      bindel = with config.lib.packages; [
        ", XF86AudioRaiseVolume, exec, ${wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, ${brightnessctl}/bin/brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, ${brightnessctl}/bin/brightnessctl s 10%-"
      ];

      bindm = [
        "${mainMod} SHIFT, mouse:272, movewindow"
        "${mainMod} SHIFT, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "opacity ${toString kitty.settings.background_opacity} class:kitty"
        "opacity ${toString ghostty.settings.background-opacity}, class:ghostty"
        "suppressevent maximize, class:.*"
        "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
