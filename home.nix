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
        "ventoy-gtk3"
        "corefonts"
      ];
    permittedInsecurePackages = [ "ventoy-gtk3-1.1.05" ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      profile-sync-daemon = prev.profile-sync-daemon.overrideAttrs (oldAttrs: {
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
  home.sessionVariables.DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";

  home.packages = with pkgs; [
    templ
    zig
    rustup
    swi-prolog
    python314
    nodejs_24
    (dotnetCorePackages.combinePackages [
      dotnet-sdk_8
      dotnet-sdk_9
    ])

    unzip
    zip
    p7zip
    rar
    cifs-utils
    powertop
    trash-cli

    sl
    lolcat
    cowsay
    cmatrix
    mongosh
    tlrc
    ncdu
    sqlite
    dysk
    umu-launcher-unwrapped

    gimp3
    openshot-qt
    resources
    qbittorrent-enhanced
    postman
    drawio
    ventoy-full-gtk
    sfxr
    libreoffice
    teams-for-linux
    tor-browser

    (config.lib.nixGL.wrapOffload brave)
    (config.lib.nixGL.wrapOffload godot_4)
    (config.lib.nixGL.wrapOffload obs-studio)
    (config.lib.nixGL.wrapOffload discord)
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
  programs.thunderbird.enable = true;
  programs.mpv.enable = true;
  programs.mpvpaper.enable = true;
  programs.yt-dlp.enable = true;

  programs.firefox.package = config.lib.nixGL.wrapOffload pkgs.firefox;
  programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;
  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;
  programs.mpvpaper.package = config.lib.nixGL.wrap pkgs.mpvpaper;

  services.playerctld.enable = true;
  services.psd.enable = true;
  services.podman.enable = true;
  services.easyeffects.enable = true;
  services.poweralertd.enable = true;
  services.network-manager-applet.enable = true;

  xdg.configFile."systemd/user/network-manager-applet.service.d/override.conf".enable =
    config.services.network-manager-applet.enable;
  xdg.configFile."systemd/user/hyprpaper.service.d/override.conf".enable =
    config.services.hyprpaper.enable;
  xdg.configFile."systemd/user/dconf.service.d/override.conf".enable = config.dconf.enable;

  xdg.configFile."systemd/user/network-manager-applet.service.d/override.conf".text = ''
    [Service]
    Restart=on-failure
  '';
  xdg.configFile."systemd/user/hyprpaper.service.d/override.conf".text = ''
    [Unit]
    Conflicts=mpvpaper.service
  '';
  xdg.configFile."systemd/user/dconf.service.d/override.conf".text = ''
    [Install]
    WantedBy=default.target
  '';

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
      package = pkgs.darkly-qt5;
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
    ./mozilla
    ./nvim
    ./yazi
    ./hyprland
    ./audio
    ./games
    ./ghostty
    ./kitty.nix
    ./zsh.nix
    ./tmux.nix
    ./container.nix
    ./fonts.nix
    ./fcitx5.nix
    ./xdg-desktop-portal.nix
    ./mpvpaper.nix
  ];
}
