{ config, lib, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {
    config.allowUnfreePredicate =
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
      ];
    config.permittedInsecurePackages = [ "ventoy-gtk3-1.1.05" ];
  };
in
{
  nix.package = pkgsUnstable.nix;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.overlays = [
    (self: super: {
      inherit (pkgsUnstable)
        less
        xdg-desktop-portal
        networkmanagerapplet
        poweralertd
        systemd
        ;
      profile-sync-daemon = pkgsUnstable.profile-sync-daemon.overrideAttrs (oldAttrs: {
        installPhase = ''
          ${oldAttrs.installPhase}
          cp $out/share/psd/contrib/brave $out/share/psd/browsers/brave
        '';
      });
    })
  ];

  nixGL = {
    packages = import <nixgl> { inherit ({ pkgs = pkgsUnstable; }) pkgs; };
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

  home.packages = with pkgsUnstable; [
    libgcc
    libpkgconf
    cmake
    gnumake
    debugedit
    fakeroot

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
    package = pkgsUnstable.dracula-theme;
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
  programs.jq.package = pkgsUnstable.jq;
  programs.jqp.package = pkgsUnstable.jqp;
  programs.lazydocker.package = pkgsUnstable.lazydocker;
  programs.ripgrep.package = pkgsUnstable.ripgrep;
  programs.fd.package = pkgsUnstable.fd;

  services.playerctld.enable = true;
  services.psd.enable = true;
  services.podman.enable = true;
  services.easyeffects.enable = true;
  services.poweralertd.enable = true;

  services.playerctld.package = pkgsUnstable.playerctl;
  services.podman.package = pkgsUnstable.podman;
  services.easyeffects.package = pkgsUnstable.easyeffects;

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.glibcLocales = pkgsUnstable.glibcLocales.override {
    locales = [ "en_US.UTF-8/UTF-8" ];
  };

  i18n.inputMethod.fcitx5.fcitx5-with-addons = pkgsUnstable.fcitx5-with-addons;
  i18n.inputMethod.fcitx5.addons = with pkgsUnstable; [
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
      color_theme = "${pkgsUnstable.btop}/share/btop/themes/tokyo-storm.theme";
      theme_background = false;
      vim_keys = true;
    };
  };

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
