{
  common,
  packages,
  yaziFlavors,
}:
{
  hyprlock = import ./hyprlock.nix;
  thunderbird.profiles.${common.username}.isDefault = true;
  firefox = import ./firefox.nix {
    inherit (common) username;
    inherit (packages) nur;
  };
  yazi = import ./yazi.nix {
    inherit yaziFlavors;
    inherit (packages.yaziExtra) hexyl glow;
    inherit (packages)
      neovim
      mpv
      eza
      yaziPlugins
      ;
  };
  bash.profileExtra =
    let
      uwsm = packages.hyprlandExtra.uwsm;
    in
    ''
      start_profile() {
          local answer environment default_id
          [[ "$(tty)" = "/dev/tty1" ]] || return
          ${uwsm}/bin/uwsm check may-start || return
          environment="your wayland environment"
          [[ -f "$HOME/.config/uwsm/default-id" ]] && read -r default_id < "$HOME/.config/uwsm/default-id"
          [[ -n "$default_id" ]] && environment="''${default_id%.*}"
          read -p "Do you want to start $environment? (Y/n): " -rn 1 answer
          echo
          [[ "$answer" = "Y" ]] && exec ${uwsm}/bin/uwsm start default
          [[ "$answer" = "n" ]] && ${uwsm}/bin/uwsm select && exec ${uwsm}/bin/uwsm start default
      }
      start_profile
    '';
  zsh = import ./zsh.nix {
    inherit (packages) fastfetch;
  };
  tmux = import ./tmux.nix {
    inherit (packages) zsh tmuxPlugins;
  };
  ghostty = import ./ghostty.nix {
    inherit (packages) zsh;
  };
  kitty = (
    import ./kitty.nix {
      inherit (packages) zsh;
    }
  );
  neovim = import ./neovim.nix {
    inherit (packages)
      vimPlugins
      pyright
      ruff
      nil
      nixfmt-rfc-style
      lua-language-server
      roslyn-ls
      stylua
      ccls
      prettierd
      vscode-langservers-extracted
      emmet-language-server
      tailwindcss-language-server
      typescript-language-server
      yaml-language-server
      taplo
      gopls
      dockerfile-language-server-nodejs
      docker-compose-language-service
      bash-language-server
      shfmt
      svelte-language-server
      rust-analyzer
      zls
      tree-sitter
      gdtoolkit_4
      ;
  };
  waybar = import ./waybar.nix {
    inherit (packages.hyprlandExtra) uwsm hyprsysteminfo;
    inherit (packages)
      firefox
      btop
      kitty
      ghostty
      yazi
      neovide
      wlogout
      easyeffects
      swaync
      playerctl
      pwvucontrol
      helvum
      brave
      wireplumber
      ncdu
      ;
  };
  zoxide.enableZshIntegration = true;
  git = {
    userName = "TranThangBin";
    userEmail = "thangdev04@gmail.com";
  };
  fzf = {
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  btop.settings = {
    color_theme = "${packages.btop}/share/btop/themes/tokyo-storm.theme";
    theme_background = false;
    vim_keys = true;
  };
  mpvpaper = {
    pauseList = " ";
    stopList = ''
      steam
      wineserver
    '';
  };
  wofi = {
    style = ''
      @import url("${../common.css}");
      @import url("${../catppuccin-mocha.css}");
      @import url("${./wofi.css}");
    '';
    settings = {
      columns = 2;
      width = "60%";
      hide_scroll = true;
      insensitive = true;
      allow_images = true;
      key_up = "Ctrl-k";
      key_down = "Ctrl-j";
      key_left = "Ctrl-h";
      key_right = "Ctrl-l";
      key_expand = "Ctrl-space";
    };
  };
}
