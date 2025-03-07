{ config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Manage hyprland with your os package manager
    systemd.variables = [ "--all" ];
    settings = {
      monitor = ",preferred,auto,1";

      "$kitty" = "${config.programs.kitty.package}/bin/kitty";
      "$ghostty" = "${config.programs.ghostty.package}/bin/ghostty";

      "$terminal" = "$ghostty";
      "$fileManager" = "${pkgs.kdePackages.dolphin}/bin/dolphin";
      "$menu" = "${pkgs.wofi}/bin/wofi --show drun";

      exec-once = [
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "${pkgs.waybar}/bin/waybar"
        ''gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"''
        ''gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"''
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "QT_QPA_PLATFORMTHEME,qt6ct"
        "XDG_DATA_DIRS,${builtins.getEnv "XDG_DATA_DIRS"}"
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

      master = { new_status = "master"; };

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
        touchpad = { natural_scroll = false; };
      };

      gestures = { workspace_swipe = false; };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      "$mainMod" = "ALT";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod SHIFT, Q, killactive,"
        "$mainMod SHIFT, E, exit,"
        "$mainMod, E, exec, $fileManager"
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

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, M, togglespecialworkspace, magic"
        "$mainMod SHIFT, M, movetoworkspace, special:magic"

        "$mainMod CTRL SHIFT, L, workspace, e+1"
        "$mainMod CTRL SHIFT, H, workspace, e-1"

        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"
      ];

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
        "opacity 0.95 0.95, class:kitty"
        "suppressevent maximize, class:.*"
        "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
