{
  config,
  lib,
  pkgs,
  ...
}:
{
  nix.package = pkgs.nix;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      lib.elem (lib.getName pkg) [
        "drawio"
        "nvidia"
        "discord"
        "postman"
        "rar"
        "steam"
        "steam-unwrapped"
        "nixGL-steam"
        "ventoy-gtk3"
        "corefonts"
      ];
    permittedInsecurePackages = [ "ventoy-gtk3-1.1.05" ];
  };

  nixpkgs.overlays = [
    (self: super: {
      profile-sync-daemon = super.profile-sync-daemon.overrideAttrs (oldAttrs: {
        installPhase = ''
          ${oldAttrs.installPhase}
          cp $out/share/psd/contrib/brave $out/share/psd/browsers/brave
        '';
      });
    })
  ];

  nixGL = {
    packages = pkgs.nixgl;
    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = [
      "mesa"
      "nvidiaPrime"
    ];
  };

  home.username = "trant";
  home.homeDirectory = "/home/trant";

  programs.git.userName = "TranThangBin";
  programs.git.userEmail = "thangdev04@gmail.com";

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    templ
    zig
    rustup
    python314
    nodejs_24
    swi-prolog

    unzip
    zip
    p7zip
    rar
    cifs-utils
    yt-dlp
    powertop
    trash-cli

    imagemagick
    exiftool
    wl-clipboard-rs
    xclip
    xsel
    ueberzugpp

    sl
    lolcat
    cowsay
    cmatrix
    mongosh
    tlrc
    ncdu
    uwsm
    sqlite
    dysk
    umu-launcher-unwrapped

    gimp3
    openshot-qt
    vlc
    brave
    resources
    qbittorrent-enhanced
    postman
    drawio
    ventoy-full-gtk
    sfxr
    libreoffice

    (config.lib.nixGL.wrapOffload godot_4)
    (config.lib.nixGL.wrapOffload obs-studio)
    (config.lib.nixGL.wrapOffload discord)
    (config.lib.nixGL.wrapOffload steam)
  ];

  targets.genericLinux.enable = true;

  xdg.portal.enable = true;

  xdg.userDirs.enable = true;

  fonts.fontconfig.enable = true;

  home.pointerCursor.gtk.enable = true;

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 28;
  };

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
  programs.jq.enable = true;
  programs.jqp.enable = true;
  programs.lazydocker.enable = true;
  programs.ripgrep.enable = true;
  programs.fd.enable = true;

  programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;

  services.playerctld.enable = true;
  services.psd.enable = true;
  services.podman.enable = true;
  services.easyeffects.enable = true;
  services.poweralertd.enable = true;

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.glibcLocales = pkgs.glibcLocales.override {
    locales = [ "en_US.UTF-8/UTF-8" ];
  };

  i18n.inputMethod.fcitx5.addons = with pkgs; [
    kdePackages.fcitx5-unikey
    fcitx5-tokyonight
  ];

  qt.enable = true;
  gtk.enable = true;

  programs.zoxide.enableZshIntegration = true;
  programs.fzf = {
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };
  programs.btop = {
    settings = {
      color_theme = "${pkgs.btop}/share/btop/themes/tokyo-storm.theme";
      theme_background = false;
      vim_keys = true;
    };
  };

  qt = {
    platformTheme = {
      name = "qt5ct";
      package = pkgs.libsForQt5.qt5ct;
    };
    style = {
      name = "Darkly";
      package = pkgs.Darkly-qt5;
    };
  };

  gtk = {
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
  };

  imports = [
    ./firefox
    ./nvim
    ./yazi
    ./hyprland
    ./audio
    ./kitty.nix
    ./ghostty.nix
    ./zsh.nix
    ./tmux.nix
    ./container.nix
    ./fonts.nix
    ./games.nix
    ./fcitx5.nix
    ./xdg-desktop-portal.nix
  ];
}
