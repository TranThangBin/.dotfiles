{ config, pkgs, ... }:
{
  nixGL.packages = import <nixgl> { inherit pkgs; };
  nixGL.defaultWrapper = "mesa";
  nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = [
    "mesa"
    "nvidiaPrime"
  ];

  imports = [
    ./waybar.nix
    ./wofi.nix
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
      bun
      go
      templ
      zig
      rustup
      nodejs_23
      openjdk
      python311

      ripgrep
      fd
      htop
      fastfetch
      powertop
      gnumake
      cmake
      pkg-config

      hyprshot
      networkmanagerapplet
      brightnessctl
      resources
      kdePackages.dolphin
      kdePackages.qt6ct
      firefox

      pipewire
      wireplumber
      pwvucontrol
      helvum
      alsa-utils
      alsa-firmware
      alsa-tools
      alsa-lib

      docker
      lazydocker
      rootlesskit

      nixfmt-rfc-style
      stylua
    ];

    file = {
      ".docker/daemon.json".text = ''{ "dns": ["8.8.8.8", "8.8.4.4", "1.1.1.1"] }'';
      ".profile".text = ''
        if [[ "$(tty)" = "/dev/tty1" ]]; then
            pgrep Hyprland || Hyprland
        fi
      '';
    };

    sessionVariables = { };
  };

  xdg = {
    enable = true;
    portal.config.common.default = "*";
  };

  programs = {
    home-manager.enable = true;
    wlogout.enable = true;
    git = {
      enable = true;
      userName = "TranThangBin";
      userEmail = "thangdev04@gmail.com";
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      kdePackages.fcitx5-unikey
      fcitx5-tokyonight
    ];
  };

  services = {
    playerctld.enable = true;
    swaync.enable = true;

    hyprpaper = {
      enable = true;
      package = pkgs.hyprpaper;
      settings = {
        preload = "${config.home.homeDirectory}/.dotfiles/images/background.jpg";
        wallpaper = ", ${config.home.homeDirectory}/.dotfiles/images/background.jpg";
      };
    };
  };

  systemd.user.services = {
    docker.Service.ExecStart = "${pkgs.docker}/bin/dockerd-rootless";

    pipewire = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.pipewire}/bin/pipewire";
      };
    };

    pipewire-pulse = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.pipewire}/bin/pipewire-pulse";
      };
    };

    wireplumber = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wireplumber}/bin/wireplumber";
      };
    };
  };
}
