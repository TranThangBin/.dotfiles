{
  config,
  lib,
  pkgs,
  yaziFlavors,
  ...
}:
let
  hyprlandEnabled = config.wayland.windowManager.hyprland.enable;
  wrap = config.lib.nixGL.wrap;
  wrapOffload = config.lib.nixGL.wrapOffload;
  mkMerge = lib.mkMerge;
  systemctlPath = config.systemd.user.systemctlPath;
  waylandSystemdTarget = config.wayland.systemd.target;
  preferedWallpaper = ./wallpapers/Snow-valley.jpg;
  preferedVideopaper = "https://youtu.be/YhUPi6-MQNE?si=zS7PKwOmwxQeGQhf";
  gamesDir = "${config.home.homeDirectory}/Games";
  umuConfigDir = "${gamesDir}/umu/config";
  binaries = builtins.listToAttrs (
    builtins.map
      (path: {
        name = builtins.baseNameOf path + "Bin";
        value =
          assert builtins.pathExists path;
          builtins.baseNameOf path;
      })
      [
        "/usr/bin/sudo"
        "/usr/bin/mktemp"
        "/usr/bin/pidof"
        "/usr/bin/hyprlock"
        "/usr/bin/hyprctl"
      ]
  );
  packages =
    {
      xdg-desktop-portal-hyprland = config.wayland.windowManager.hyprland.finalPortalPackage;
    }
    // (with config.programs; {
      fastfetch = fastfetch.package;
      zsh = zsh.package;
      btop = btop.package;
      yazi = yazi.package;
      wlogout = wlogout.package;
      firefox = firefox.finalPackage;
      kitty = kitty.package;
      ghostty = ghostty.package;
      mpv = mpv.package;
      neovim = neovim.finalPackage;
      neovide = neovide.package;
      mpvpaper = mpvpaper.package;
    })
    // (with config.services; {
      easyeffects = easyeffects.package;
      swaync = swaync.package;
      podman = podman.package;
      playerctl = playerctld.package;
    })
    // (with pkgs; {
      inherit
        nur
        podman-compose
        hexyl
        glow
        eza
        systemd
        xdg-desktop-portal
        xdg-desktop-portal-termfilechooser
        pipewire
        wireplumber
        brightnessctl
        umu-launcher-unwrapped
        yaziPlugins
        tmuxPlugins
        vimPlugins
        pyright
        ruff
        nil
        nixfmt-rfc-style
        lua-language-server
        roslyn-ls
        stylua
        ccls
        prettierd
        vscode-langservers-extracted
        emmet-language-server
        tailwindcss-language-server
        typescript-language-server
        yaml-language-server
        taplo
        gopls
        dockerfile-language-server-nodejs
        docker-compose-language-service
        bash-language-server
        shfmt
        svelte-language-server
        rust-analyzer
        zls
        tree-sitter
        gdtoolkit_4
        ;
    });
in
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

  home.stateVersion = "25.05";
  home.sessionVariables.DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";

  home.packages = builtins.attrValues config.lib.packages;

  lib.packages = builtins.listToAttrs (
    builtins.map
      (package: rec {
        name = if builtins.isString package then package else package.name;
        value =
          if builtins.isAttrs package && package ? wrapFn then package.wrapFn pkgs.${name} else pkgs.${name};
      })
      (
        [
          "templ"
          "zig"
          "rustup"
          "swi-prolog"
          "nodejs_24"
          "unzip"
          "zip"
          "p7zip"
          "rar"
          "cifs-utils"
          "trash-cli"
          "sl"
          "lolcat"
          "cowsay"
          "cmatrix"
          "mongosh"
          "tlrc"
          "sqlite"
          "dysk"
          "umu-launcher-unwrapped"
          "gimp3"
          "openshot-qt"
          "resources"
          "qbittorrent-enhanced"
          "postman"
          "drawio"
          "ventoy-full-gtk"
          "sfxr"
          "libreoffice"
          "teams-for-linux"
          "tor-browser"
          "pipewire"
          "wireplumber"
          "pwvucontrol"
          "helvum"
          "alsa-utils"
          "alsa-tools"
          "alsa-lib"
          "alsa-plugins"
          "openal"
          "umu-launcher-unwrapped"
          "systemd"
          "brightnessctl"
          "ncdu"
          {
            name = "brave";
            wrapFn = wrapOffload;
          }
          {
            name = "obs-studio";
            wrapFn = wrapOffload;
          }
          {
            name = "discord";
            wrapFn = wrapOffload;
          }
        ]
        ++ lib.lists.optionals hyprlandEnabled [
          "uwsm"
          "wev"
          "hyprshot"
          "hyprpicker"
          "wofi-emoji"
          "wl-clipboard"
          {
            name = "hyprsysteminfo";
            wrapFn = wrap;
          }
        ]
        ++ lib.lists.optionals config.programs.yazi.enable [
          "imagemagick"
          "exiftool"
          "wl-clipboard"
          "xclip"
          "xsel"
          "ueberzugpp"
          "hexyl"
          "glow"
          "eza"
        ]
        ++ lib.lists.optional config.services.podman.enable "podman-compose"
      )
  );

  programs = mkMerge [
    {
      hyprlock.package = pkgs.emptyDirectory; # Manage hyprlock with your os package manager
      firefox.package = wrapOffload pkgs.firefox;
      kitty.package = wrap pkgs.kitty;
      ghostty.package = wrap pkgs.ghostty;
      mpv.package = wrapOffload pkgs.mpv;
      mpvpaper.package = wrapOffload pkgs.mpvpaper;
      neovide.package = wrap pkgs.neovide;
    }
    (import ./programs {
      inherit yaziFlavors hyprlandEnabled mkMerge;
      inherit (config.home) username;
      inherit (config.xdg) configHome;
      inherit (config.lib.scripts) wofiUwsmWrapped;
      inherit (config.lib.packages)
        uwsm
        pwvucontrol
        helvum
        hyprsysteminfo
        brave
        wireplumber
        ncdu
        ;
      inherit (binaries) mktempBin sudoBin;
      inherit (packages)
        fastfetch
        zsh
        btop
        yazi
        wlogout
        firefox
        kitty
        ghostty
        mpv
        neovide
        easyeffects
        swaync
        playerctl
        neovim
        nur
        hexyl
        glow
        eza
        yaziPlugins
        tmuxPlugins
        vimPlugins
        pyright
        ruff
        nil
        nixfmt-rfc-style
        lua-language-server
        roslyn-ls
        stylua
        ccls
        prettierd
        vscode-langservers-extracted
        emmet-language-server
        tailwindcss-language-server
        typescript-language-server
        yaml-language-server
        taplo
        gopls
        dockerfile-language-server-nodejs
        docker-compose-language-service
        bash-language-server
        shfmt
        svelte-language-server
        rust-analyzer
        zls
        tree-sitter
        gdtoolkit_4
        ;
    })
  ];

  services = import ./services {
    inherit
      mkMerge
      hyprlandEnabled
      systemctlPath
      preferedWallpaper
      waylandSystemdTarget
      ;
    inherit (binaries)
      pidofBin
      hyprlockBin
      hyprctlBin
      ;
    inherit (packages)
      podman-compose
      systemd
      brightnessctl
      playerctl
      ;
  };

  systemd = mkMerge [
    { user.systemctlPath = "${packages.systemd}/bin/systemctl"; }
    (import ./systemd {
      inherit mkMerge waylandSystemdTarget preferedVideopaper;
      inherit (packages)
        podman
        mpvpaper
        pipewire
        wireplumber
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-termfilechooser
        ;
    })
  ];

  targets.genericLinux.enable = true;

  fonts.fontconfig.enable = true;

  home.pointerCursor.gtk.enable = true;

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 28;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null; # Manage hyprland with your os package manager

  xdg = mkMerge [
    {
      userDirs.enable = true;
      portal = {
        enable = true;
        config = {
          common.default = [ "hyprland" ];
          hyprland.default = [ "hyprland" ];
        };
      };
      configFile = {
        "uwsm/env".enable = hyprlandEnabled;
        "uwsm/env-hyprland".enable = hyprlandEnabled;
        "systemd/user/network-manager-applet.service.d/override.conf".enable =
          config.services.network-manager-applet.enable;
        "systemd/user/hyprpaper.service.d/override.conf".enable = config.services.hyprpaper.enable;
        "systemd/user/dconf.service.d/override.conf".enable = config.dconf.enable;
      };
    }
    (import ./xdg {
      inherit mkMerge gamesDir umuConfigDir;
      inherit (config.lib.scripts) minecraft;
      inherit (packages)
        firefox
        umu-launcher-unwrapped
        pipewire
        ;
    })
  ];

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.inputMethod.fcitx5.fcitx5-with-addons = pkgs.fcitx5-with-addons;

  qt.enable = true;
  gtk.enable = true;

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
    ./scripts
    ./hyprland
    ./audio
    ./container.nix
    ./fonts.nix
    ./fcitx5.nix
  ];
}
