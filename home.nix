{ pkgs, lib, ... }:
let
  languages = with pkgs; [
    gcc
    templ
    zig
    rustup
    nodejs_23
    python311
  ];
  controlTools = with pkgs; [
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
  buildTools = with pkgs; [
    gnumake
    cmake
    pkg-config
  ];
  cliTools = with pkgs; [
    ripgrep
    fd
    powertop
    docker
    lazydocker
    mongosh
    tldr
    htop
    ncdu
  ];
  guiTools = with pkgs; [
    resources
    drawio
    gimp
  ];
in
{
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
  ];

  home = {
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";
    stateVersion = "25.05";
    packages = languages ++ controlTools ++ buildTools ++ cliTools ++ guiTools;
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
      exec =
        with pkgs;
        "${jdk}/bin/java -jar ${
          fetchurl {
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

  gtk = with pkgs; {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      package = nerd-fonts.fira-code;
      size = 12;
    };
    theme = {
      name = "Dracula";
      package = dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = dracula-icon-theme;
    };
    cursorTheme = {
      name = "Dracula";
      package = dracula-theme;
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

  systemd.user.services = with pkgs; {
    docker.Service.ExecStart = "${docker}/bin/dockerd-rootless";

    pipewire = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pipewire}/bin/pipewire";
      };
    };

    pipewire-pulse = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${pipewire}/bin/pipewire-pulse";
      };
    };

    wireplumber = {
      Install = {
        WantedBy = [ "default.target" ];
      };
      Service = {
        ExecStart = "${wireplumber}/bin/wireplumber";
        Restart = "always";
      };
    };
  };
}
