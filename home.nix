{ pkgs, lib, ... }:
{
  nix.package = pkgs.nix;

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
    ./nvim
    ./hyprland.nix
    ./kitty.nix
    ./ghostty.nix
    ./zsh.nix
    ./tmux.nix
    ./firefox.nix
  ];

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "25.05";

    packages = with pkgs; [
      gcc
      go
      templ
      zig
      rustup
      nodejs_23
      python311

      nixfmt-rfc-style
      stylua

      ripgrep
      fd
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

      resources
      drawio
      gimp

      pipewire
      wireplumber
      pwvucontrol
      helvum
      brightnessctl
      alsa-utils
      alsa-firmware
      alsa-tools
      alsa-lib
      fuse-overlayfs
    ];
  };

  xdg = {
    enable = true;
    configFile."docker/daemon.json".text =
      ''{ "dns": ["8.8.8.8", "8.8.4.4", "1.1.1.1"], "dns-search": ["local"] }'';
    desktopEntries.LegacyLauncher = {
      type = "Application";
      name = "Legacy Launcher";
      genericName = "Minecraft";
      prefersNonDefaultGPU = true;
      exec = "${pkgs.jdk}/bin/java -jar ${
        pkgs.fetchurl {
          url = "https://llaun.ch/jar";
          hash = "sha256-3y0lFukFzch6aOxFb4gWZKWxWLqBCTQlHXtwp0BnlYg=";
        }
      }";
    };
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
    bat.enable = true;
    bun.enable = true;
    go.enable = true;
    java.enable = true;
    fastfetch.enable = true;
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
        Restart = "always";
      };
    };
  };
}
