{
  uwsm,
  ghostty,
  btop,
  yazi,
  wofiScript,
  clipboardPickerScript,
  clipboardDeleteScript,
  clipboardWipeScript,
  hyprshot,
  wlogout,
  hyprpicker,
  wofi-emoji,
  swayosd,
  kittyBackgroundOpacity,
  ghosttyBackgroundOpacity,
  pkillBin,
}:
let
  catppuccin-mocha = import ./catppuccin-mocha.nix;
  pink = catppuccin-mocha.pink;
  surface0 = catppuccin-mocha.surface0;
  flamingo = catppuccin-mocha.flamingo;
  mainMod = "SUPER";
  mainMonitor = "eDP-2";
  hdmiMonitor = "HDMI-A-1";
  clipboard = {
    picker = "${clipboardPickerScript}";
    delete = "${clipboardDeleteScript}";
    wipe = "${clipboardWipeScript}";
  };
  screenshot = {
    save = {
      region = "${hyprshot}/bin/hyprshot -m region";
      window = "${hyprshot}/bin/hyprshot -m window";
      output = "${hyprshot}/bin/hyprshot -m output";
    };
    clipboard = {
      region = "${hyprshot}/bin/hyprshot -m region --clipboard-only";
      window = "${hyprshot}/bin/hyprshot -m window --clipboard-only";
      output = "${hyprshot}/bin/hyprshot -m output --clipboard-only";
    };
  };
in
{
  settings = {
    animations = {
      enabled = true;
      animation = "workspaces, 1, 8, default, fade";
    };
    gestures.workspace_swipe = false;
    master.new_status = "master";

    monitor = [
      "${mainMonitor},preferred,auto,1"
      "${hdmiMonitor},preferred,auto,1"
      # "${hdmiMonitor},preferred,auto,1,mirror,${mainMonitor}"
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
        "${mainMod}, Return, exec, ${uwsm}/bin/uwsm-app ${ghostty}/bin/ghostty"
        "${mainMod}, R, exec, ${uwsm}/bin/uwsm-app ${btop}/share/applications/btop.desktop"
        "${mainMod}, E, exec, ${uwsm}/bin/uwsm-app ${yazi}/share/applications/yazi.desktop"
        "${mainMod}, Space, exec, ${wofiScript}"
        "${mainMod} SHIFT, E, exec, ${wlogout}/bin/wlogout"
        "${mainMod}, C, exec, ${hyprpicker}/bin/hyprpicker"
        "${mainMod} SHIFT, Space, exec, ${wofi-emoji}/bin/wofi-emoji"

        "${mainMod}, V, exec, ${clipboard.picker}"
        "${mainMod} SHIFT, V, exec, ${clipboard.delete}"
        "${mainMod} CTRL SHIFT, V, exec, ${clipboard.wipe}"

        "${mainMod}, PRINT, exec, ${screenshot.save.region}"
        "${mainMod} SHIFT, PRINT, exec, ${screenshot.save.window}"
        "${mainMod} CTRL SHIFT, PRINT, exec, ${screenshot.save.output}"

        ",PRINT, exec, ${screenshot.clipboard.region}"
        "SHIFT, PRINT, exec, ${screenshot.clipboard.window}"
        "CTRL SHIFT, PRINT, exec, ${screenshot.clipboard.output}"
      ]
      ++ [
        "${mainMod}, code:23, exec, ${pkillBin} -SIGUSR1 waybar"
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
      ++ builtins.concatLists (
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
        ++ builtins.genList (i: [
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

    bindl = [
      ", XF86AudioNext, exec, ${swayosd}/bin/swayosd-client --playerctl next"
      ", XF86AudioPause, exec,${swayosd}/bin/swayosd-client --playerctl play-pause"
      ", XF86AudioPlay, exec, ${swayosd}/bin/swayosd-client --playerctl play-pause"
      ", XF86AudioPrev, exec,${swayosd}/bin/swayosd-client --playerctl previous"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, ${swayosd}/bin/swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume, exec, ${swayosd}/bin/swayosd-client --output-volume lower"
      ", XF86AudioMute, exec, ${swayosd}/bin/swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, ${swayosd}/bin/swayosd-client --input-volume mute-toggle"
      ", XF86MonBrightnessUp, exec, ${swayosd}/bin/swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, ${swayosd}/bin/swayosd-client --brightness lower"
    ];

    bindm = [
      "${mainMod} SHIFT, mouse:272, movewindow"
      "${mainMod} SHIFT, mouse:273, resizewindow"
    ];

    bindc = [
      "Caps_Lock, Caps_Lock, exec, ${swayosd}/bin/swayosd-client --caps-lock"
      "Mod2, Num_Lock, exec, ${swayosd}/bin/swayosd-client --num-lock"
    ];

    workspace = [
      "1, monitor:${mainMonitor}, default:true"
      "2, monitor:${mainMonitor}, default:true"
      "3, monitor:${mainMonitor}, default:true"
      "4, monitor:${mainMonitor}, default:true"
      "5, monitor:${mainMonitor}, default:true"
      "6, monitor:${hdmiMonitor}, default:true"
      "7, monitor:${hdmiMonitor}, default:true"
      "8, monitor:${hdmiMonitor}, default:true"
      "9, monitor:${hdmiMonitor}, default:true"
      "10, monitor:${hdmiMonitor}, default:true"
    ];

    windowrulev2 = [
      "opacity ${toString kittyBackgroundOpacity} class:kitty"
      "opacity ${toString ghosttyBackgroundOpacity}, class:ghostty"
      "suppressevent maximize, class:.*"
      "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
    ];
  };
}
