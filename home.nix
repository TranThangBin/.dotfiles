{ pkgs, ... }:
let
  hyprlandAvailable = builtins.pathExists "/usr/bin/Hyprland";
in
{
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
    ./waybar
    ./wofi
    ./nvim
    ./hyprpaper
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./kitty.nix
    ./ghostty.nix
    ./zsh.nix
    ./tmux.nix
    ./firefox.nix
  ];

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "24.11";

    packages = with pkgs; [
      gcc
      go
      templ
      zig
      rustup
      nodejs_23
      openjdk
      python311

      nixfmt-rfc-style
      stylua

      ripgrep
      fd
      fastfetch
      gnumake
      cmake
      pkg-config
      powertop
      docker
      lazydocker
      mongosh
      tldr
      htop
      ncdu

      hyprshot
      brightnessctl
      resources
      gimp
      kdePackages.dolphin
      kdePackages.qt6ct

      pipewire
      wireplumber
      pwvucontrol
      helvum
      alsa-utils
      alsa-firmware
      alsa-tools
      alsa-lib
      fuse-overlayfs
    ];

    file = {
      ".profile" = {
        enable = hyprlandAvailable;
        text = ''
          if [[ "$(tty)" = "/dev/tty1" ]]; then
              ${pkgs.fastfetch}/bin/fastfetch
          	printf "Do you want to start Hyprland? (Y/n): "
          	read -rn 1 answer
              echo
          	if [[ "$answer" = "Y" ]]; then
          		pgrep Hyprland || Hyprland
          	fi
          fi
        '';
      };
    };
  };

  xdg = {
    enable = true;
    portal.config.common.default = "*";
    configFile."docker/daemon.json".text =
      ''{ "dns": ["8.8.8.8", "8.8.4.4", "1.1.1.1"], "dns-search": ["local"] }'';
  };

  qt = {
    enable = true;
    style = {
      name = "Dracula";
      package = pkgs.dracula-qt5-theme;
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      package = pkgs.nerd-fonts.fira-code;
      size = 12;
    };
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

  programs = {
    home-manager.enable = true;
    wlogout.enable = hyprlandAvailable;
    bat.enable = true;
    bun.enable = true;
    go.enable = true;
    ssh = {
      enable = true;
      package = pkgs.openssh;
    };
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
    yazi = {
      enable = true;
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
    network-manager-applet.enable = true;
    swaync.enable = hyprlandAvailable;
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
