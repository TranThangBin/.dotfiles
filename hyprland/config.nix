{
  pkgs,
  config,
  lib,
  ...
}:
let
  pkgsUnstable = import <nixpkgs-unstable> { };

  mainMod = "SUPER";

  settings = with config.programs; {
    terminal = {
      kitty = "${kitty.package}/bin/kitty";
      ghostty = "${ghostty.package}/bin/ghostty";
    };
    logoutMenu = "${wlogout.package}/bin/wlogout";
    fileManager = "${yazi.package}/share/applications/yazi.desktop";
    menuOutput = ''${wofi.package}/bin/wofi --show drun --define=drun-print_desktop_file=true | sed -E "s/(\.desktop) /\1:/"'';
    resourceMonitor = "${btop.package}/share/applications/btop.desktop";
    colorPicker = "${pkgsUnstable.hyprpicker}/bin/hyprpicker -a";
  };

  flamingo = "rgb(f2cdcd)";
  pink = "rgb(f5c2e7)";
  surface0 = "rgb(313244)";

in
{
  wayland.windowManager.hyprland = {
    portalPackage = pkgsUnstable.xdg-desktop-portal-hyprland;
    systemd.enable = false;
    settings = {
      monitor = [
        ",preferred,auto,1"
        "HDMI-A-1,1920x1080,auto,1,mirror,eDP-2"
      ];

      exec-once =
        (with config.systemd.user; [
          "${systemctlPath} --user stop network-manager-applet.service"
          "${systemctlPath} --user start network-manager-applet.service"
          "${systemctlPath} --user stop dconf.service"
          "${systemctlPath} --user start dconf.service"
        ])
        ++ (with pkgsUnstable; [
          "${uwsm}/bin/uwsm app -- ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
          "${uwsm}/bin/uwsm app -- ${config.wayland.windowManager.hyprland.portalPackage}/libexec/xdg-desktop-portal-hyprland"
          # "${uwsm}/bin/uwsm app -- ${xdg-desktop-portal-termfilechooser}/libexec/xdg-desktop-portal-termfilechooser"
        ]);

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = pink;
        "col.inactive_border" = surface0;
        "col.nogroup_border_active" = flamingo;
        "col.nogroup_border" = surface0;
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
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

      animations = {
        enabled = true;
        bezier = "myBezier, 0.3, 1, 0.7, 1";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        follow_mouse = 1;
        sensitivity = 2;
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      bind =
        (
          with pkgsUnstable;
          [
            "${mainMod}, Return, exec, ${uwsm}/bin/uwsm-app ${settings.terminal.ghostty}"
            "${mainMod}, Space, exec, ${uwsm}/bin/uwsm-app $( ${settings.menuOutput} )"
            "${mainMod}, R, exec, ${uwsm}/bin/uwsm-app ${settings.resourceMonitor}"
            "${mainMod}, E, exec, ${uwsm}/bin/uwsm-app ${settings.fileManager}"
            "${mainMod} SHIFT, E, exec, ${settings.logoutMenu}"
            "${mainMod}, C, exec, ${settings.colorPicker}"
          ]
          ++ [
            "${mainMod}, PRINT, exec, ${hyprshot}/bin/hyprshot -m region"
            "${mainMod} SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m window"
            "${mainMod} CTRL SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m output"

            ",PRINT, exec, ${hyprshot}/bin/hyprshot -m region --clipboard-only"
            "SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m window --clipboard-only"
            "CTRL SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m output --clipboard-only"
          ]
        )
        ++ [
          "${mainMod} SHIFT, Q, killactive,"
          "${mainMod}, F, fullscreen,"
          "${mainMod} SHIFT, F, togglefloating,"
          "${mainMod}, P, pseudo,"
          "${mainMod} CTRL SHIFT, J, togglesplit,"
        ]
        ++ [
          "${mainMod}, M, togglespecialworkspace, magic"
          "${mainMod} SHIFT, M, movetoworkspace, special:magic"

          "${mainMod} CTRL SHIFT, L, workspace, e+1"
          "${mainMod} CTRL SHIFT, H, workspace, e-1"

          "${mainMod}, L, movefocus, r"
          "${mainMod} SHIFT, L, movewindow, r"

          "${mainMod}, H, movefocus, l"
          "${mainMod} SHIFT, H, movewindow, l"

          "${mainMod}, K, movefocus, u"
          "${mainMod} SHIFT, K, movewindow, u"

          "${mainMod}, J, movefocus, d"
          "${mainMod} SHIFT, J, movewindow, d"
        ]
        ++ (
          lib.concatLists (
            lib.genList (i: [
              "${mainMod}, code:1${toString i}, workspace, ${toString (i + 1)}"
              "${mainMod} SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
            ]) 9
          )
          ++ [
            "${mainMod}, 0, workspace, 10"
            "${mainMod} SHIFT, 0, movetoworkspace, 10"
          ]
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

      bindel = with pkgsUnstable; [
        ", XF86AudioRaiseVolume, exec, ${wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
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

      windowrulev2 =
        [
          "suppressevent maximize, class:.*"
          "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        ]
        ++ (with config.programs; [
          "opacity ${toString kitty.settings.background_opacity} class:kitty"
          "opacity ${toString ghostty.settings.background-opacity}, class:ghostty"
        ]);
    };
  };
}
