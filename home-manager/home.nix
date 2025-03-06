{ config, pkgs, lib, ... }:

let
  homeDir = config.home.homeDirectory;
  kittyPkg = config.lib.nixGL.wrap pkgs.kitty;
  PATH = builtins.getEnv "PATH";
  XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };
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
      kdePackages.dolphin
      hyprshot
      kdePackages.qt6ct
    ];

    file = { };

    sessionVariables = { };
  };

  xdg.portal.config.common.default = "*";

  xdg.configFile = { nvim.source = "${homeDir}/.dotfiles/nvim"; };

  programs = {
    wofi.enable = true;
    home-manager.enable = true;
    hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          color = "rgba(25, 20, 20, 1.0)";
          blur_passes = 0;
          blur_size = 7;
          noise = 1.17e-2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };

        input-field = {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = false;
          dots_rounding = -1;
          dots_fade_time = 200;
          dots_text_format = "";
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          font_family = "FiraMono Nerd Font";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Input Password...</i>";
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 2000;
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };

    waybar = {
      enable = true;
      style = ''
        @define-color base   #1e1e2e;
        @define-color mantle #181825;
        @define-color crust  #11111b;

        @define-color text     #cdd6f4;
        @define-color subtext0 #a6adc8;
        @define-color subtext1 #bac2de;

        @define-color surface0 #474862;
        @define-color surface1 #45475a;
        @define-color surface2 #585b70;

        @define-color overlay0 #6c7086;
        @define-color overlay1 #7f849c;
        @define-color overlay2 #9399b2;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        * {
          font-family: FiraMono Nerd Font;
          font-size: 17px;
          min-height: 0;
        }

        #waybar {
          background: transparent;
          color: @text;
          margin: 5px 5px;
        }

        #workspaces {
          border-radius: 1rem;
          margin: 5px;
          background-color: @surface0;
          margin-left: 1rem;
        }

        #workspaces button {
          color: @lavender;
          border-radius: 1rem;
          padding: 0.4rem;
        }

        #workspaces button.active {
          color: @sky;
          border-radius: 1rem;
        }

        #workspaces button:hover {
          color: @sapphire;
          border-radius: 1rem;
        }

        #custom-music,
        #tray,
        #backlight,
        #clock,
        #battery,
        #pulseaudio,
        #custom-lock,
        #custom-power {
          background-color: @surface0;
          padding: 0.5rem 1rem;
          margin: 5px 0;
        }

        #clock {
          color: @blue;
          border-radius: 0px 1rem 1rem 0px;
          margin-right: 1rem;
        }

        #battery {
          color: @green;
        }

        #battery.charging {
          color: @green;
        }

        #battery.warning:not(.charging) {
          color: @red;
        }

        #backlight {
          color: @yellow;
        }

        #backlight, #battery {
            border-radius: 0;
        }

        #pulseaudio {
          color: @maroon;
          border-radius: 1rem 0px 0px 1rem;
          margin-left: 1rem;
        }

        #custom-music {
          color: @mauve;
          border-radius: 1rem;
        }

        #custom-lock {
            border-radius: 1rem 0px 0px 1rem;
            color: @lavender;
        }

        #custom-power {
            margin-right: 1rem;
            border-radius: 0px 1rem 1rem 0px;
            color: @red;
        }

        #tray {
          margin-right: 1rem;
          border-radius: 1rem;
        }
      '';
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
            format = " {icon} ";
            format-icons = { default = ""; };
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
            exec =
              "${pkgs.playerctl}/bin/playerctl metadata --format='{{ title }}'";
            on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
            max-length = 50;
          };
          clock = {
            timezone = "Asia/Dubai";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            format-alt = " {:%d/%m/%Y}";
            format = " {:%H:%M}";
          };
          backlight = {
            device = "intel_backlight";
            format = "{icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" ];
          };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon}";
            format-charging = "";
            format-plugged = "";
            format-alt = "{icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" "" "" "" ];
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "";
            format-icons = { default = [ "" "" " " ]; };
            on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
          };
          "custom/lock" = {
            tooltip = false;
            on-click =
              "sh -c '(sleep 0.5s; ${pkgs.hyprlock}/bin/hyprlock)' & disown";
            format = "";
          };
          "custom/power" = {
            tooltip = false;
            on-click = "wlogout &";
            format = "襤";
          };
        };
      };
    };

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
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        nvim-web-devicons
        vim-obsession
        telescope-nvim
        harpoon2
        rose-pine
        tokyonight-nvim
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        nvim-lspconfig
        SchemaStore-nvim
        lsp-zero-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip
        friendly-snippets
        lsp-overloads-nvim
        lazydev-nvim
        luvit-meta
        none-ls-nvim
        undotree
        vim-godot
        netrw-nvim
        nvim-autopairs
        nvim-ts-autotag
        nvim-surround
        oil-nvim
        comment-nvim
        nvim-treesitter-context
        vim-fugitive
        telescope-fzf-native-nvim
        todo-comments-nvim
        fidget-nvim
        gitsigns-nvim
        trouble-nvim
        zen-mode-nvim
      ];
      extraPackages = with pkgs; [
        nil
        nixfmt-rfc-style
        lua-language-server
        stylua
        clang-tools
      ];
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initExtra = "[ -z $TMUX ] && fastfetch";
      envExtra = ''
        export ZSH=$HOME/.nix-profile/share/oh-my-zsh
        export PATH=$HOME/go/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:${PATH}
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
    fcitx5.addons = with pkgs.kdePackages; [ fcitx5-unikey ];
  };

  services = {
    playerctld.enable = true;
    swaync.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd =
            "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }

          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }

          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }

          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }

          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];

      };
    };
    hyprpaper = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.hyprpaper;
      settings = {
        preload = "${homeDir}/.dotfiles/images/background.jpg";
        wallpaper = ", ${homeDir}/.dotfiles/images/background.jpg";
      };
    };
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
    systemd.variables = [ "--all" ];
    settings = {
      monitor = ",preferred,auto,1";

      "$terminal" = "${kittyPkg}/bin/kitty";
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
        "XDG_DATA_DIRS,${XDG_DATA_DIRS}"
      ];

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
        "$mainMod, P, pseudo,"
        "$mainMod CTRL SHIFT, J, togglesplit,"
        ", PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m window"
        "SHIFT, PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m region"
        "$mainMod CTRL SHIFT, S, exec, ${pkgs.hyprlock}/bin/hyprlock"

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
        "opacity 0.95 0.95, class:kitty"
        "suppressevent maximize, class:.*"
        "prop nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
      ];
    };
  };
}
