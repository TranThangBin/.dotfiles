{ pkgs, lib, ... }:
{
  home.username = "trant";
  home.homeDirectory = "/home/trant";

  programs.git.userName = "TranThangBin";
  programs.git.userEmail = "thangdev04@gmail.com";

  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    gcc
    templ
    zig
    rustup
    nodejs_23
    python311

    unzip
    gnumake
    cmake
    pkg-config

    ripgrep
    fd
    brightnessctl
    powertop
    mongosh
    tldr
    htop
    btop
    ncdu

    resources
    drawio
    gimp
    vlc
  ];

  wayland.windowManager.hyprland.enable = true;

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

  xdg.enable = true;

  services.playerctld.enable = true;
  services.network-manager-applet.enable = true;

  i18n.inputMethod.enabled = "fcitx5";

  qt.enable = true;
  gtk.enable = true;

  programs.ssh.package = pkgs.openssh;
  programs.zoxide.enableZshIntegration = true;
  programs.fzf = {
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
  };

  i18n.inputMethod.fcitx5.addons = with pkgs; [
    kdePackages.fcitx5-unikey
    fcitx5-tokyonight
  ];

  qt.style = {
    name = "Dracula";
    package = pkgs.dracula-qt5-theme;
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
    cursorTheme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "drawio" ];

  nixGL = {
    packages = import <nixgl> { inherit pkgs; };
    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = [
      "mesa"
      "nvidiaPrime"
    ];
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
  ];
}
