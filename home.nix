{
  pkgs,
  config,
  lib,
  ...
}:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  nix.package = pkgsUnstable.nix;

  nix.settings = {
    experimental-features = [ ];
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "drawio"
      "nvidia"
      "discord"
    ];

  nixpkgs.overlays = [
    (self: super: {
      less = pkgsUnstable.less;
      networkmanagerapplet = pkgsUnstable.networkmanagerapplet;
      xdg-desktop-portal = pkgsUnstable.xdg-desktop-portal;
    })
  ];

  nixGL = {
    packages = import <nixgl> { inherit pkgs; };
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
    gcc
    templ
    zig
    rustup
    python311
    nodejs_23
    swi-prolog

    unzip
    zip
    gnumake
    cmake
    pkg-config
    jq

    ripgrep
    fd
    sl
    lolcat
    cowsay
    cmatrix
    powertop
    mongosh
    tlrc
    htop
    btop
    ncdu
    sqlite

    resources
    gimp
    vlc
    umu-launcher-unwrapped

    (config.lib.nixGL.wrapOffload godot_4)
    (config.lib.nixGL.wrapOffload pkgs.discord)
    (config.lib.nixGL.wrapOffload pkgsUnstable.obs-studio)

    pkgs.drawio
  ];

  xdg.userDirs.enable = true;

  systemd.user.systemctlPath = "${pkgsUnstable.systemd}/bin/systemctl";

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null; # Manage hyprland with your os package manager

  fonts.fontconfig.enable = true;

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

  programs.man.package = pkgsUnstable.man;
  programs.firefox.package = config.lib.nixGL.wrapOffload pkgsUnstable.firefox;
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

  services.playerctld.enable = true;
  services.network-manager-applet.enable = true;

  services.playerctld.package = pkgsUnstable.playerctl;

  i18n.inputMethod.enabled = "fcitx5";

  qt.enable = true;
  gtk.enable = true;

  programs.zoxide.enableZshIntegration = true;
  programs.fzf = {
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
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
    cursorTheme = {
      name = "Dracula";
      package = pkgsUnstable.dracula-theme;
    };
  };

  imports = [
    ./firefox
    ./nvim
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
