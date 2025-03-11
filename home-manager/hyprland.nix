{ config, pkgs, ... }:
let
  kitty = "${config.programs.kitty.package}/bin/kitty";
  ghostty = "${config.programs.ghostty.package}/bin/ghostty";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Manage hyprland with your os package manager
    systemd.variables = [ "--all" ];
    settings = {
      monitor = ",preferred,auto,1";

      "$terminal" = ghostty;
      "$fileManager" = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      "$menu" = "${config.home.file.".local/bin/wofi.sh".source}";

      env = [
        "XCURSOR_SIZE,12"
        "HYPRCURSOR_SIZE,12"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "MOZ_ENABLE_WAYLAND,1"
        "XDG_DATA_DIRS,${builtins.getEnv "XDG_DATA_DIRS"}"
        "XDG_DATA_HOME,${builtins.getEnv "XDG_DATA_HOME"}"
        "PATH,${builtins.getEnv "PATH"}"
      ];

      exec-once = [
        "systemctl start --user dconf"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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
        sensitivity = 0;
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

      "$mainMod" = "ALT";

      bind =
        [
          "$mainMod, Return, exec, $terminal"
          "$mainMod SHIFT, Q, killactive,"
          "$mainMod SHIFT, E, exit,"
          "$mainMod, E, exec, $fileManager"
          "$mainMod, F, fullscreen,"
          "$mainMod SHIFT, F, togglefloating,"
          "$mainMod, Space, exec, $menu"
          "$mainMod, P, pseudo,"
          "$mainMod CTRL SHIFT, J, togglesplit,"
          ", PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m window"
          "SHIFT, PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
          "$mainMod CTRL SHIFT, S, exec, hyprlock"

          "$mainMod, L, movefocus, r"
          "$mainMod, H, movefocus, l"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          "$mainMod, M, togglespecialworkspace, magic"
          "$mainMod SHIFT, M, movetoworkspace, special:magic"

          "$mainMod CTRL SHIFT, L, workspace, e+1"
          "$mainMod CTRL SHIFT, H, workspace, e-1"

          "$mainMod SHIFT, L, movewindow, r"
          "$mainMod SHIFT, H, movewindow, l"
          "$mainMod SHIFT, K, movewindow, u"
          "$mainMod SHIFT, J, movewindow, d"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              "$mainMod, code:1${toString i}, workspace, ${toString ws}"
              "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          ) 9
        ));

      bindm = [
        "$mainMod SHIFT, mouse:272, movewindow"
        "$mainMod SHIFT, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
        "$mainMod CTRL, L, resizeactive, 10 0"
        "$mainMod CTRL, H, resizeactive, -10 0"
        "$mainMod CTRL, K, resizeactive, 0 -10"
        "$mainMod CTRL, J, resizeactive, 0 10"
      ];

      bindl = [
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ];

      windowrulev2 = [
        "opacity 0.95 0.95, class:kitty|class:ghostty"
        "suppressevent maximize, class:.*"
        "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
