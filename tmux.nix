let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    mouse = false;
    customPaneNavigationAndResize = true;
    shell = "${pkgsUnstable.zsh}/bin/zsh";
    terminal = "screen-256color";
    escapeTime = 10;
    extraConfig = ''
      set-option -g focus-events on
      bind -N "Create a new session" C-c new-session
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
    plugins = with pkgsUnstable.tmuxPlugins; [
      cpu
      battery
      copycat
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-processes '"~nvim->nvim"'
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          run ${catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g status-right "#{E:@catppuccin_status_application}"
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -ag status-right "#{E:@catppuccin_status_uptime}"
          set -agF status-right "#{E:@catppuccin_status_battery}"
          run ${cpu}/share/tmux-plugins/cpu/cpu.tmux
          run ${battery}/share/tmux-plugins/battery/battery.tmux
        '';
      }
    ];
  };
}
