{
  mkMerge,
  hyprlandEnabled,
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
  wofiUwsmWrapped,
  mktempBin,
  sudoBin,
}:
mkMerge [
  {
    hyprlock.enable = hyprlandEnabled;
    waybar.enable = hyprlandEnabled;
    wofi.enable = hyprlandEnabled;
    wlogout.enable = hyprlandEnabled;
    home-manager.enable = true;
    firefox.enable = true;
    kitty.enable = true;
    ghostty.enable = true;
    bash.enable = true;
    zsh.enable = true;
    tmux.enable = true;
    bat.enable = true;
    bun.enable = true;
    go.enable = true;
    java.enable = true;
    fastfetch.enable = true;
    ssh.enable = true;
    git.enable = true;
    lazygit.enable = true;
    yazi.enable = true;
    zoxide.enable = true;
    fzf.enable = true;
    less.enable = true;
    btop.enable = true;
    jq.enable = true;
    jqp.enable = true;
    lazydocker.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    thunderbird.enable = true;
    mpv.enable = true;
    mpvpaper.enable = true;
    yt-dlp.enable = true;
    neovim.enable = true;
    neovide.enable = true;
  }
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
        wofiUwsmWrapped
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
    wofi.settings = {
      columns = 2;
      width = "60%";
      hide_scroll = true;
      insensitive = true;
      allow_images = true;
      style = "${./wofi.css}";
      key_up = "Ctrl-k";
      key_down = "Ctrl-j";
      key_left = "Ctrl-h";
      key_right = "Ctrl-l";
      key_expand = "Ctrl-space";
    };
  }
]
