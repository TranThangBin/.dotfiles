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
  bash = import ./bash.nix {
    inherit uwsm configHome;
  };
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
  thunderbird.profiles.${username}.isDefault = true;
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
