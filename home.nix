{
  config,
  lib,
  pkgs,
  yaziFlavors,
  legacyLauncher,
  ...
}:
let
  common = {
    inherit (config.home) username;
    inherit (lib) mkMerge;
    inherit (config.lib.nixGL) wrap wrapOffload;
    inherit (config.systemd.user) systemctlPath;

    dotfilesDir = "$HOME/.dotfiles";
    scriptPath = "${config.home.homeDirectory}/.local/bin";
    gamesDir = "${config.home.homeDirectory}/Games";

    preferedWallpaper = ./wallpapers/Snow-valley.jpg;
    preferedVideopaper = "https://youtu.be/YhUPi6-MQNE?si=zS7PKwOmwxQeGQhf";

    waylandSystemdTarget = config.wayland.systemd.target;

    kittyBackgroundOpacity = config.programs.kitty.settings.background_opacity;
    ghosttyBackgroundOpacity = config.programs.ghostty.settings.background-opacity;
  };

  packages =
    {
      xdg-desktop-portal-hyprland = config.wayland.windowManager.hyprland.finalPortalPackage;
    }
    // import ./packages.nix {
      inherit config lib pkgs;
    };

  scriptDependencies = {
    inherit (packages.hyprlandExtra) uwsm wl-clipboard;
    inherit (packages)
      wofi
      toybox
      cliphist
      neovim
      neovide
      cifs-utils
      go
      ;
  };
in
{
  nix.package = packages.nix;

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
        "rider"
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
      ncdu = prev.ncdu.overrideAttrs (prevAttrs: {
        postInstall = ''
          ${prevAttrs.postInstall}
          mkdir -p $out/share/applications
          cat << EOF > $out/share/applications/ncdu.desktop
          [Desktop Entry]
          Categories=Utility;Core;System;FileTools;FileManager;ConsoleOnly
          Comment=Disk usage analyzer with an ncurses interface
          Exec=ncdu %f
          Keywords=System;Explorer;Browser
          MimeType=inode/directory
          Name=Ncdu
          Terminal=true
          Type=Application
          Version=1.4
          Icon=${./images/Ncdu.png}
          EOF
        '';
      });
    })
  ];

  nixGL = {
    packages = packages.nixgl;
    defaultWrapper = "mesa";
    offloadWrapper = "nvidiaPrime";
    installScripts = [
      "mesa"
      "nvidiaPrime"
    ];
  };

  home.username = "trant";
  home.homeDirectory = "/home/trant";
  home.stateVersion = "25.05";
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.hyprcursor.enable = config.wayland.windowManager.hyprland.enable;
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 28;
  };
  home.shellAliases = {
    docker = "${packages.podman}/bin/podman";
  };
  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    PODMAN_COMPOSE_PROVIDER = "${packages.podmanExtra.podman-compose}/bin/podman-compose";
  };
  home.packages =
    with packages;
    [
      corefonts
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      templ
      zig
      rustup
      swi-prolog
      nodejs_24
      unzip
      zip
      p7zip
      rar
      cifs-utils
      trash-cli
      sl
      lolcat
      cowsay
      cmatrix
      mongosh
      tlrc
      sqlite
      dysk
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
      alsa-utils
      alsa-tools
      alsa-lib
      alsa-plugins
      openal
      pipewire
      wireplumber
      pwvucontrol
      helvum
      umu-launcher-unwrapped
      brightnessctl
      ncdu
      brave
      obs-studio
      discord
      jetbrains.rider
    ]
    ++ builtins.attrValues (builtins.removeAttrs hyprlandExtra [ "hyprland" ])
    ++ builtins.attrValues yaziExtra
    ++ builtins.attrValues podmanExtra;
  home.file = common.mkMerge (
    [
      {
        ".asoundrc".source = "${packages.pipewire}/share/alsa/alsa.conf.d/99-pipewire-default.conf";
        "${common.scriptPath}/dependencies".source = pkgs.symlinkJoin {
          name = "script-dependencies";
          paths = builtins.attrValues scriptDependencies;
        };
      }
    ]
    ++ builtins.map (scriptFile: {
      "${common.scriptPath}/${scriptFile}" = {
        executable = true;
        source = "${./scripts}/${scriptFile}";
      };
    }) (builtins.attrNames (builtins.readDir ./scripts))
  );

  programs = common.mkMerge [
    {
      hyprlock.enable = config.wayland.windowManager.hyprland.enable;
      waybar.enable = config.wayland.windowManager.hyprland.enable;
      wofi.enable = config.wayland.windowManager.hyprland.enable;
      wlogout.enable = config.wayland.windowManager.hyprland.enable;
      eza.enable = config.programs.yazi.enable;
      home-manager.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      ghostty.enable = true;
      bash.enable = true;
      zsh.enable = true;
      tmux.enable = true;
      bat.enable = true;
      bun.enable = true;
      go.enable = true;
      java.enable = true;
      fastfetch.enable = true;
      ssh.enable = true;
      git.enable = true;
      lazygit.enable = true;
      yazi.enable = true;
      zoxide.enable = true;
      fzf.enable = true;
      less.enable = true;
      btop.enable = true;
      jq.enable = true;
      jqp.enable = true;
      lazydocker.enable = true;
      ripgrep.enable = true;
      fd.enable = true;
      thunderbird.enable = true;
      mpv.enable = true;
      mpvpaper.enable = true;
      yt-dlp.enable = true;
      neovim.enable = true;
      neovide.enable = true;
      distrobox.enable = true;
    }
    {
      hyprlock.package = packages.emptyDirectory; # Manage hyprlock with your os package manager
      firefox.package = common.wrapOffload pkgs.firefox;
      kitty.package = common.wrap pkgs.kitty;
      ghostty.package = common.wrap pkgs.ghostty;
      mpv.package = common.wrapOffload pkgs.mpv;
      mpvpaper.package = common.wrapOffload pkgs.mpvpaper;
      neovide.package = common.wrap pkgs.neovide;
    }
    (import ./programs {
      inherit yaziFlavors common packages;
    })
  ];

  services = common.mkMerge [
    {
      swaync.enable = config.wayland.windowManager.hyprland.enable;
      cliphist.enable = config.wayland.windowManager.hyprland.enable;
      hyprpaper.enable = config.wayland.windowManager.hyprland.enable;
      hypridle.enable = config.wayland.windowManager.hyprland.enable;
      hyprsunset.enable = config.wayland.windowManager.hyprland.enable;
      swayosd.enable = config.wayland.windowManager.hyprland.enable;
      playerctld.enable = true;
      psd.enable = true;
      podman.enable = true;
      easyeffects.enable = true;
      poweralertd.enable = true;
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    }
    (import ./services {
      inherit common packages;
    })
  ];

  systemd = common.mkMerge [
    { user.systemctlPath = "${packages.systemd}/bin/systemctl"; }
    (import ./systemd {
      inherit common packages;
    })
  ];

  targets.genericLinux.enable = true;

  fonts = common.mkMerge [
    { fontconfig.enable = true; }
    { fontconfig = import ./fontconfig.nix; }
  ];

  wayland.systemd.target =
    if config.wayland.windowManager.hyprland.enable then
      "wayland-session@hyprland.desktop.target"
    else
      "graphical-session.target";
  wayland.windowManager.hyprland = common.mkMerge [
    {
      enable = true;
      package = null; # Manage hyprland with your os package manager
      systemd.enable = false;
    }
    (import ./hyprland.nix {
      inherit common packages;
    })
  ];

  xdg = common.mkMerge [
    (import ./xdg {
      inherit common packages legacyLauncher;
    })
    {
      userDirs.enable = true;
      portal = {
        enable = true;
        config = lib.attrsets.optionalAttrs config.wayland.windowManager.hyprland.enable {
          common = {
            default = [ "hyprland" ];
            "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          };
          hyprland.default = [ "hyprland" ];
        };
        extraPortals = with packages; [ xdg-desktop-portal-termfilechooser ];
      };
      configFile = {
        "uwsm/env".enable = config.wayland.windowManager.hyprland.enable;
        "uwsm/env-hyprland".enable = config.wayland.windowManager.hyprland.enable;
        "systemd/user/network-manager-applet.service.d/override.conf".enable =
          config.services.network-manager-applet.enable;
        "systemd/user/hyprpaper.service.d/override.conf".enable = config.services.hyprpaper.enable;
      };
    }
  ];

  i18n = common.mkMerge [
    {
      inputMethod.fcitx5 = import ./fcitx5.nix {
        inherit packages;
      };
    }
    {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.fcitx5-with-addons = packages.fcitx5-with-addons;
        fcitx5.waylandFrontend = config.wayland.windowManager.hyprland.enable;
      };
    }
  ];

  qt.enable = true;
  gtk.enable = true;

  qt = {
    platformTheme = {
      name = "qt5ct";
      package = packages.libsForQt5.qt5ct;
    };
    style = {
      name = "Darkly";
      package = packages.darkly-qt5;
    };
  };

  gtk = {
    theme = {
      name = "Dracula";
      package = packages.dracula-theme;
    };
    iconTheme = {
      name = "Dracula";
      package = packages.dracula-icon-theme;
    };
  };
}
