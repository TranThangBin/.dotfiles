{ config, pkgs, ... }: {
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [ "mesa" "nvidiaPrime" ];

  imports = [
    ./waybar.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./kitty.nix
    ./ghostty.nix
    ./zsh.nix
    ./tmux.nix
    ./nvim.nix
  ];

  home = {
    username = "trant";
    homeDirectory = "/home/" + config.home.username;
    stateVersion = "24.11";

    packages = with pkgs; [
      gcc
      glibc
      ripgrep
      fd
      gnumake
      htop
      bun
      fzf
      go
      zig
      rustup
      nodejs_23
      fastfetch
      nixfmt-classic
      powertop
      cmake
      pkg-config
      pipewire
      pwvucontrol
      wireplumber
      networkmanagerapplet
      kdePackages.dolphin
      hyprshot
      kdePackages.qt6ct
      brightnessctl
      stylua
      openjdk
      resources
      squirreldisk
    ];

    file = { };

    sessionVariables = { };
  };

  xdg = {
    enable = true;
    portal.config.common.default = "*";
  };

  programs = {
    wofi.enable = true;
    home-manager.enable = true;
    wlogout.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs.kdePackages; [ fcitx5-unikey ];
  };

  services = {
    playerctld.enable = true;
    swaync.enable = true;

    hyprpaper = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.hyprpaper;
      settings = {
        preload =
          "${config.home.homeDirectory}/.dotfiles/images/background.jpg";
        wallpaper =
          ", ${config.home.homeDirectory}/.dotfiles/images/background.jpg";
      };
    };
  };

  systemd.user.services = {
    pipewire = {
      Install = { WantedBy = [ "default.target" ]; };
      Service = { ExecStart = "${pkgs.pipewire}/bin/pipewire"; };
    };

    pipewire-pulse = {
      Install = { WantedBy = [ "default.target" ]; };
      Service = { ExecStart = "${pkgs.pipewire}/bin/pipewire-pulse"; };
    };

    wireplumber = {
      Install = { WantedBy = [ "default.target" ]; };
      Service = { ExecStart = "${pkgs.wireplumber}/bin/wireplumber"; };
    };
  };
}
