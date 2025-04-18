{
  pkgs,
  config,
  pkgsUnstable,
  lib,
  nixgl,
  ...
}:
let
in
{
  nix.package = pkgsUnstable.nix;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    lib.elem (lib.getName pkg) [
      "drawio"
      "nvidia"
      "discord"
      "postman"
      "rar"
      # "steam"
      # "nixGL-steam"
      # "steam-unwrapped"
    ];

  nixpkgs.overlays = [
    (self: super: {
      inherit (pkgsUnstable) less xdg-desktop-portal;
      profile-sync-daemon = pkgsUnstable.profile-sync-daemon.overrideAttrs (old: {
        installPhase =
          (old.installPhase or "")
          + ''
            cp $out/share/psd/contrib/brave $out/share/psd/browsers/brave
          '';
      });
    })
  ];

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = [
      "mesa"
      "nvidiaPrime"
    ];
  };

  home.enableNixpkgsReleaseCheck = false;

  home.username = "trant";
  home.homeDirectory = "/home/trant";

  programs.git.userName = "TranThangBin";
  programs.git.userEmail = "thangdev04@gmail.com";

  home.stateVersion = "25.05";

  home.packages = with pkgsUnstable; [
    templ
    zig
    rustup
    python311
    nodejs_23
    swi-prolog

    unzip
    zip
    libreoffice
    jq
    cifs-utils

    imagemagick
    exiftool
    wl-clipboard
    xclip
    xsel
    ueberzugpp

    systemd
    ripgrep
    fd
    sl
    lolcat
    cowsay
    cmatrix
    mongosh
    tlrc
    ncdu
    uwsm
    sqlite

    gimp
    vlc
    umu-launcher
    brave
    resources

    (config.lib.nixGL.wrapOffload godot_4)
    (config.lib.nixGL.wrapOffload obs-studio)
    (config.lib.nixGL.wrapOffload pkgs.discord)
    # (config.lib.nixGL.wrapOffload pkgs.steam)

    pkgs.postman
    pkgs.drawio
    pkgs.rar
  ];

  xdg.userDirs.enable = true;

  fonts.fontconfig.enable = true;

  home.pointerCursor.gtk.enable = true;

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgsUnstable.dracula-theme;
    size = 28;
  };

  systemd.user.systemctlPath = "${pkgsUnstable.systemd}/bin/systemctl";

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null; # Manage hyprland with your os package manager

  programs.home-manager.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.kitty.enable = true;
  programs.ghostty.enable = true;
  programs.zsh.enable = true;
  programs.tmux.enable = true;
  programs.bat.enable = true;
  programs.bun.enable = true;
  programs.go.enable = true;
  programs.java.enable = true;
  programs.fastfetch.enable = true;
  programs.ssh.enable = true;
  programs.git.enable = true;
  programs.yazi.enable = true;
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.less.enable = true;
  programs.btop.enable = true;

  programs.man.package = pkgsUnstable.man;
  programs.firefox.package = pkgsUnstable.firefox;
  programs.neovim.package = pkgsUnstable.neovim-unwrapped;
  programs.kitty.package = config.lib.nixGL.wrap pkgsUnstable.kitty;
  programs.ghostty.package = config.lib.nixGL.wrap pkgsUnstable.ghostty;
  programs.zsh.package = pkgsUnstable.zsh;
  programs.tmux.package = pkgsUnstable.tmux;
  programs.bat.package = pkgsUnstable.bat;
  programs.bun.package = pkgsUnstable.bun;
  programs.go.package = pkgsUnstable.go;
  programs.java.package = pkgsUnstable.jdk;
  programs.fastfetch.package = pkgsUnstable.fastfetch;
  programs.ssh.package = pkgsUnstable.openssh;
  programs.git.package = pkgsUnstable.git;
  programs.yazi.package = pkgsUnstable.yazi;
  programs.zoxide.package = pkgsUnstable.zoxide;
  programs.fzf.package = pkgsUnstable.fzf;
  programs.btop.package = pkgsUnstable.btop;

  services.playerctld.enable = true;
  services.psd.enable = true;

  services.playerctld.package = pkgsUnstable.playerctl;

  i18n.inputMethod.enabled = "fcitx5";

  qt.enable = true;
  gtk.enable = true;

  programs.zoxide.enableZshIntegration = true;
  programs.fzf = {
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  programs.btop = {
    settings = {
      color_theme = "${pkgsUnstable.btop}/share/btop/themes/tokyo-storm.theme";
      theme_background = false;
      vim_keys = true;
    };
  };

  i18n.inputMethod.fcitx5.addons = with pkgsUnstable; [
    kdePackages.fcitx5-unikey
    fcitx5-tokyonight
  ];

  qt = {
    platformTheme = {
      name = "qt5ct";
      package = pkgsUnstable.libsForQt5.qt5ct;
    };
    style = {
      name = "lightly";
      package = pkgsUnstable.lightly-qt;
    };
  };

  gtk = {
    theme = {
      name = "Dracula";
      package = pkgsUnstable.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgsUnstable.dracula-icon-theme;
    };
  };

  imports = [
    ./firefox
    ./nvim
    ./yazi
    ./hyprland
    ./kitty.nix
    ./ghostty.nix
    ./zsh.nix
    ./tmux.nix
    ./docker.nix
    ./pipewire.nix
    ./fonts.nix
    ./minecraft.nix
  ];
}
