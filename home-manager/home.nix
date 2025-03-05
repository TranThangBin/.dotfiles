{ config, pkgs, ... }:

let
  homeDir = config.home.homeDirectory;
  kittyPkg = config.lib.nixGL.wrap pkgs.kitty;
in {
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "mesa" "nvidiaPrime" ];

  home = {
    username = "trant";
    homeDirectory = "/home/trant";
    stateVersion = "24.11";

    packages = with pkgs; [
      gcc
      ripgrep
      fd
      gnumake
      htop
      bun
      fzf
      go
      zig
      rustup
      nodejs_23
      fastfetch
      nixfmt-classic
      powertop
      cmake
      pkg-config
      pipewire
      pwvucontrol
      wireplumber
      networkmanagerapplet
      libsForQt5.dolphin
    ];

    file = { };

    sessionVariables = { };
  };

  xdg.portal.config.common.default = "*";

  xdg.configFile = {
    nvim.source = "${homeDir}/.dotfiles/nvim";
    ghostty.source = "${homeDir}/.dotfiles/ghostty";
    # waybar.source = "${homeDir}/.dotfiles/waybar";
  };

  programs = {
    wofi.enable = true;
    home-manager.enable = true;

    kitty = {
      enable = true;
      package = kittyPkg;
      font = {
        name = "FiraMono Nerd Font";
        size = 16;
      };
      themeFile = "GitHub_Dark_High_Contrast";
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = "[ -z $TMUX ] && fastfetch";
      envExtra = ''
        export ZSH=$HOME/.nix-profile/share/oh-my-zsh
        export PATH=$HOME/go/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
        export GTK_IM_MODULE="wayland"
        export QT_IM_MODULE="wayland;fcitx;ibus"
        export SDL_IM_MODULE="fcitx"
        export XMODIFIERS="@im=fcitx"
        export INPUT_METHOD="fcitx"
        export GLFW_IM_MODULE="ibus"
      '';
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "tmux" "vi-mode" "command-not-found" ];
        extraConfig = ''
          bindkey '^ ' autosuggest-accept
        '';
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      mouse = false;
      customPaneNavigationAndResize = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "screen-256color";
      plugins = with pkgs.tmuxPlugins; [
        cpu
        battery
        copycat

        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-processes '"~nvim->nvim *"'
            set -g @resurrect-strategy-nvim 'session'
          '';
        }

        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '0'
          '';
        }

        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor "mocha"
            set -g @catppuccin_window_status_style "rounded"
            run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux
            set -g status-right-length 100
            set -g status-left-length 100
            set -g status-left ""
            set -g status-right "#{E:@catppuccin_status_application}"
            set -agF status-right "#{E:@catppuccin_status_cpu}"
            set -ag status-right "#{E:@catppuccin_status_session}"
            set -ag status-right "#{E:@catppuccin_status_uptime}"
            set -agF status-right "#{E:@catppuccin_status_battery}"
            run ~/.config/tmux/plugins/tmux-plugins/tmux-cpu/cpu.tmux
            run ~/.config/tmux/plugins/tmux-plugins/tmux-battery/battery.tmux
          '';
        }
      ];
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs.libsForQt5; [ fcitx5-unikey fcitx5-configtool ];
  };

  systemd.user.services = {
    pipewire = {
      Install = { WantedBy = [ "default.target" ]; };
      Service = { ExecStart = "${pkgs.pipewire}/bin/pipewire"; };
    };

    pipewire-pulse = {
      Install = { WantedBy = [ "default.target" ]; };
      Service = { ExecStart = "${pkgs.pipewire}/bin/pipewire-pulse"; };
    };

    wireplumber = {
      Install = { WantedBy = [ "default.target" ]; };
      Service = { ExecStart = "${pkgs.wireplumber}/bin/wireplumber"; };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    settings = {
      monitor = ",preferred,auto,1";

      "$terminal" = "${kittyPkg}/bin/kitty";
      "$fileManager" = "${pkgs.libsForQt5.dolphin}/bin/dolphin";
      "$menu" = "${pkgs.wofi}/bin/wofi --show drun";

      exec-once = [
        "${pkgs.networkmanagerapplet}/bin/nm-applet"
        "waybar"
        "swaync"
        "hypridle"
        "${pkgs.fcitx5}/bin/fcitx5"
        "hyprpaper"
      ];

      env = [ "XCURSOR_SIZE,24" "HYPRCURSOR_SIZE,24" ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
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
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod CTRL SHIFT, J, togglesplit,"
        ", PRINT, exec, hyprshot -m window"
        "SHIFT, PRINT, exec, hyprshot -m region"
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

        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod CTRL SHIFT, L,workspace, e+1"
        "$mainMod CTRL SHIFT, H, workspace, e-1"

        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        "$mainMod CTRL, L, resizeactive, 10 0"
        "$mainMod CTRL, H, resizeactive, -10 0"
        "$mainMod CTRL, K, resizeactive, 0 -10"
        "$mainMod CTRL, J, resizeactive, 0 10"
      ];

      bindm = [
        "$mainMod SHIFT, mouse:272, movewindow"
        "$mainMod SHIFT, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
