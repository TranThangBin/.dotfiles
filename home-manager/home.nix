{ config, pkgs, ... }:

let homeDir = config.home.homeDirectory;

in {
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
      oh-my-zsh
      fira-mono
      discord-ptb
    ];

    file = { };

    sessionVariables = { };
  };

  xdg.configFile = {
    nvim.source = "${homeDir}/.dotfiles/nvim";
    ghostty.source = "${homeDir}/.dotfiles/ghostty";
  };

  programs = {
    home-manager.enable = true;
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
}
