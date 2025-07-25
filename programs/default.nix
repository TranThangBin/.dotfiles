{
  firefox,
  neovim,
  kitty,
  ghostty,
  mpv,
  neovide,
  username,
  nur,
  hexyl,
  glow,
  eza,
  yaziPlugins,
  yaziFlavors,
  uwsm,
  configHome,
  fastfetch,
  zsh,
  tmuxPlugins,
  vimPlugins,
  pyright,
  ruff,
  nil,
  nixfmt-rfc-style,
  lua-language-server,
  roslyn-ls,
  stylua,
  ccls,
  prettierd,
  vscode-langservers-extracted,
  emmet-language-server,
  tailwindcss-language-server,
  typescript-language-server,
  yaml-language-server,
  taplo,
  gopls,
  dockerfile-language-server-nodejs,
  docker-compose-language-service,
  bash-language-server,
  shfmt,
  svelte-language-server,
  rust-analyzer,
  zls,
  tree-sitter,
  gdtoolkit_4,
  btop,
  yazi,
  wlogout,
  easyeffects,
  swaync,
  playerctl,
  pwvucontrol,
  helvum,
  hyprsysteminfo,
  brave,
  wireplumber,
  ncdu,
  wofiScript,
  mktempBin,
  sudoBin,
}:
{
  hyprlock = import ./hyprlock.nix;
  thunderbird.profiles.${username}.isDefault = true;
  firefox = import ./firefox.nix {
    inherit username nur;
  };
  yazi = import ./yazi.nix {
    inherit
      neovim
      mpv
      hexyl
      glow
      eza
      yaziPlugins
      yaziFlavors
      ;
  };
  bash.profileExtra = ''
    start_profile() {
        local answer environment default_id
        [[ "$(tty)" = "/dev/tty1" ]] || return
        ${uwsm}/bin/uwsm check may-start || return
        environment="your wayland environment"
        [[ -f "${configHome}/uwsm/default-id" ]] && read -r default_id < ${configHome}/uwsm/default-id
        [[ -n "$default_id" ]] && environment="''${default_id%.*}"
        read -p "Do you want to start $environment? (Y/n): " -rn 1 answer
        echo
        [[ "$answer" = "Y" ]] && exec ${uwsm}/bin/uwsm start default
        [[ "$answer" = "n" ]] && ${uwsm}/bin/uwsm select && exec ${uwsm}/bin/uwsm start default
    }
    start_profile
  '';
  zsh = import ./zsh.nix {
    inherit fastfetch mktempBin sudoBin;
  };
  tmux = import ./tmux.nix {
    inherit
      zsh
      tmuxPlugins
      ;
  };
  ghostty = import ./ghostty.nix {
    inherit zsh;
  };
  kitty = (
    import ./kitty.nix {
      inherit zsh;
    }
  );
  neovim = import ./neovim.nix {
    inherit
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
    inherit
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
      uwsm
      pwvucontrol
      helvum
      hyprsysteminfo
      brave
      wireplumber
      ncdu
      wofiScript
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
    color_theme = "${btop}/share/btop/themes/tokyo-storm.theme";
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
