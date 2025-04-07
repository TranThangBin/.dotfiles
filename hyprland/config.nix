{
  pkgs,
  config,
  lib,
  ...
}:
let
  pkgsUnstable = import <nixpkgs-unstable> { };

  mainMod = "ALT";

  terminal = with config.programs; {
    kitty = "${kitty.package}/bin/kitty";
    ghostty = "${ghostty.package}/bin/ghostty";
  };
  fileManager = "${pkgsUnstable.kdePackages.dolphin}/bin/dolphin";
  menu = pkgsUnstable.writeShellScript "wofi.sh" ''
    #! /usr/bin/env bash

    if [[ ! $(pidof ${pkgsUnstable.wofi}/bin/wofi) ]]; then
        ${pkgsUnstable.uwsm}/bin/uwsm app -- $(${pkgsUnstable.wofi}/bin/wofi --show drun --define=drun-print_desktop_file=true)
    else
        pkill ${pkgsUnstable.wofi}/bin/wofi
    fi
  '';

  flamingo = "rgb(f2cdcd)";
  pink = "rgb(f5c2e7)";
  surface0 = "rgb(313244)";

in
{
  wayland.windowManager.hyprland = {
    portalPackage = pkgsUnstable.xdg-desktop-portal-hyprland;
    systemd.enable = false;
    settings = {
      monitor = ",preferred,auto,1";

      exec-once = with pkgsUnstable; [
        "${systemd}/bin/systemctl --user stop dconf.service"
        "${systemd}/bin/systemctl --user start dconf.service"
        "${systemd}/bin/systemctl --user stop network-manager-applet.service"
        "${systemd}/bin/systemctl --user start network-manager-applet.service"
        "${pkgsUnstable.uwsm}/bin/uwsm app -- ${pkgsUnstable.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland"
        "${pkgsUnstable.uwsm}/bin/uwsm app -- ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
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
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
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
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
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
        sensitivity = 1;
        touchpad = {
          natural_scroll = false;
        };
      };

      gestures = {
        workspace_swipe = false;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind =
        with pkgsUnstable;
        [
          "${mainMod}, Return, exec, ${uwsm}/bin/uwsm app -- ${terminal.ghostty}"
          "${mainMod} SHIFT, Q, killactive,"
          "${mainMod} SHIFT, E, exec, ${wlogout}/bin/wlogout"
          "${mainMod}, E, exec, ${uwsm}/bin/uwsm app -- ${fileManager}"
          "${mainMod}, F, fullscreen,"
          "${mainMod} SHIFT, F, togglefloating,"
          "${mainMod}, Space, exec, ${menu}"
          "${mainMod}, P, pseudo,"
          "${mainMod} CTRL SHIFT, J, togglesplit,"
          "${mainMod} CTRL SHIFT, S, exec, hyprlock"

          "${mainMod}, PRINT, exec, ${hyprshot}/bin/hyprshot -m region"
          "${mainMod} SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m window"
          "${mainMod} CTRL SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m output"

          ",PRINT, exec, ${hyprshot}/bin/hyprshot -m region --clipboard-only"
          "SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m window --clipboard-only"
          "CTRL SHIFT, PRINT, exec, ${hyprshot}/bin/hyprshot -m output --clipboard-only"
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
        ++ lib.concatLists (
          lib.genList (i: [
            "${mainMod}, code:1${toString i}, workspace, ${toString (i + 1)}"
            "${mainMod} SHIFT, code:1${toString i}, movetoworkspace, ${toString (i + 1)}"
          ]) 9
        );

      binde = [
        "${mainMod} CTRL, L, resizeactive, 10 0"
        "${mainMod} CTRL, H, resizeactive, -10 0"
        "${mainMod} CTRL, K, resizeactive, 0 -10"
        "${mainMod} CTRL, J, resizeactive, 0 10"
      ];

      bindl = with pkgsUnstable; [
        ", XF86AudioNext, exec, ${playerctl}/bin/playerctl next"
        ", XF86AudioPause, exec, ${playerctl}/bin/playerctl play-pause"
        ", XF86AudioPlay, exec, ${playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${playerctl}/bin/playerctl previous"
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

      windowrulev2 = [
        "opacity 0.95 0.95, class:kitty"
        "opacity ${toString config.programs.ghostty.settings.background-opacity}, class:ghostty"
        "suppressevent maximize, class:.*"
        "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
