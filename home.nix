{
  config,
  lib,
  pkgs,
  yaziFlavors,
  legacyLauncher,
  ...
}:
let
  common = rec {
    inherit (config.home) username homeDirectory;
    inherit (config.xdg) configHome;
    inherit (lib) mkMerge;
    inherit (config.lib.nixGL) wrap wrapOffload;
    inherit (config.systemd.user) systemctlPath;

    scriptDir = ".local/bin";
    preferedWallpaper = ./wallpapers/Snow-valley.jpg;
    preferedVideopaper = "https://youtu.be/YhUPi6-MQNE?si=zS7PKwOmwxQeGQhf";
    umuConfigDir = "${gamesDir}/umu/config";
    gamesDir = "${config.home.homeDirectory}/Games";
    hyprland = config.wayland.windowManager.hyprland;
    yazi = config.programs.yazi;
    waylandSystemdTarget = config.wayland.systemd.target;
    kittyBackgroundOpacity = config.programs.kitty.settings.background_opacity;
    ghosttyBackgroundOpacity = config.programs.ghostty.settings.background-opacity;
  };

  scriptAliases = {
    minecraftScript = "minecraft.sh";
    wofiScript = "wofi-uwsm-wrapped.sh";
    clipboardPickerScript = "clipboard-picker.sh";
    clipboardDeleteScript = "clipboard-delete.sh";
    clipboardWipeScript = "clipboard-wipe.sh";
    mountSmbScript = "mount-smb.sh";
    codeRunScript = "code-run.sh";
  };

  scripts = builtins.mapAttrs (
    name: value:
    builtins.concatStringsSep "" [
      common.homeDirectory
      "/"
      "${common.scriptDir}/run-${value}"
    ]
  ) scriptAliases;

  packages =
    {
      xdg-desktop-portal-hyprland = common.hyprland.finalPortalPackage;
    }
    // import ./packages.nix {
      inherit pkgs;
      inherit (config) programs services;
      inherit (config.lib) nixGL;
    };

  binaries = import ./binaries.nix;

  scriptDependencies = import ./script-dependencies.nix {
    inherit packages binaries legacyLauncher;
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
  home.pointerCursor.hyprcursor.enable = common.hyprland.enable;
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 28;
  };
  home.shellAliases = {
    docker = "${packages.podman}/bin/podman";
    mount-smb = scripts.mountSmbScript;
    code-run = scripts.codeRunScript;
  };
  home.sessionVariables = {
    DOTFILES_DIR = "$HOME/.dotfiles";
    SCRIPT_DIR = "$HOME/${common.scriptDir}";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    PODMAN_COMPOSE_PROVIDER = "${packages.podman-compose}/bin/podman-compose";
  };
  home.packages =
    with packages;
    let
      hyprlandExtra = lib.lists.optionals common.hyprland.enable [
        wev
        uwsm
        hyprshot
        hyprpicker
        wofi-emoji
        wl-clipboard
        hyprsysteminfo
      ];
      yaziExtra = lib.lists.optionals common.yazi.enable [
        imagemagick
        exiftool
        ueberzugpp
        hexyl
        glow
        eza
        wl-clipboard
      ];
      podmanExtra = lib.lists.optional config.services.podman.enable packages.podman-compose;
    in
    hyprlandExtra
    ++ yaziExtra
    ++ podmanExtra
    ++ [
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
    ];
  home.file = common.mkMerge (
    [
      {
        ".asoundrc".source = "${packages.pipewire}/share/alsa/alsa.conf.d/99-pipewire-default.conf";
      }
    ]
    ++ builtins.concatLists (
      builtins.map (scriptFile: [
        {
          "${common.scriptDir}/${scriptFile}" = {
            executable = true;
            source = "${./scripts}/${scriptFile}";
          };
        }
        {
          "${common.scriptDir}/run-${scriptFile}" = {
            executable = true;
            text = ''
              #!/usr/bin/env bash
              ${common.homeDirectory}/${config.home.file."${common.scriptDir}/${scriptFile}".target} \
                  ${builtins.concatStringsSep " " scriptDependencies.${scriptFile}} "$@"
            '';
          };
        }
      ]) (builtins.attrNames (builtins.readDir ./scripts))
    )
  );

  programs = common.mkMerge [
    {
      hyprlock.enable = common.hyprland.enable;
      waybar.enable = common.hyprland.enable;
      wofi.enable = common.hyprland.enable;
      wlogout.enable = common.hyprland.enable;
      eza.enable = common.yazi.enable;
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
      inherit yaziFlavors;
      inherit (common) username configHome;
      inherit (scripts) wofiScript;
      inherit (binaries) mktempBin sudoBin;
      inherit (packages)
        uwsm
        pwvucontrol
        helvum
        hyprsysteminfo
        brave
        wireplumber
        ncdu
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

  services = common.mkMerge [
    {
      swaync.enable = common.hyprland.enable;
      cliphist.enable = common.hyprland.enable;
      hyprpaper.enable = common.hyprland.enable;
      hypridle.enable = common.hyprland.enable;
      hyprsunset.enable = common.hyprland.enable;
      swayosd.enable = common.hyprland.enable;
      playerctld.enable = true;
      psd.enable = true;
      podman.enable = true;
      easyeffects.enable = true;
      poweralertd.enable = true;
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    }
    (import ./services {
      inherit (common)
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
        swayosd
        ;
    })
  ];

  systemd = common.mkMerge [
    { user.systemctlPath = "${packages.systemd}/bin/systemctl"; }
    (import ./systemd {
      inherit (common)
        mkMerge
        waylandSystemdTarget
        preferedVideopaper
        ;
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

  fonts = common.mkMerge [
    { fontconfig.enable = true; }
    { fontconfig = import ./fontconfig.nix; }
  ];

  wayland.systemd.target =
    if common.hyprland.enable then
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
      inherit (common)
        kittyBackgroundOpacity
        ghosttyBackgroundOpacity
        ;
      inherit (binaries) pkillBin;
      inherit (scripts)
        wofiScript
        clipboardPickerScript
        clipboardDeleteScript
        clipboardWipeScript
        ;
      inherit (packages)
        uwsm
        ghostty
        btop
        yazi
        hyprshot
        wlogout
        hyprpicker
        wofi-emoji
        swayosd
        ;
    })
  ];

  xdg = common.mkMerge [
    (import ./xdg {
      inherit (common)
        mkMerge
        gamesDir
        umuConfigDir
        ;
      inherit (scripts) minecraftScript;
      inherit (packages)
        firefox
        umu-launcher-unwrapped
        pipewire
        ;
    })
    {
      userDirs.enable = true;
      portal = {
        enable = true;
        config = lib.mkIf common.hyprland.enable {
          common = {
            default = [ "hyprland" ];
            "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          };
          hyprland.default = [ "hyprland" ];
        };
        extraPortals = with packages; [ xdg-desktop-portal-termfilechooser ];
      };
      configFile = {
        "uwsm/env".enable = common.hyprland.enable;
        "uwsm/env-hyprland".enable = common.hyprland.enable;
        "systemd/user/network-manager-applet.service.d/override.conf".enable =
          config.services.network-manager-applet.enable;
        "systemd/user/hyprpaper.service.d/override.conf".enable = config.services.hyprpaper.enable;
      };
    }
  ];

  i18n = common.mkMerge [
    {
      inputMethod.fcitx5 = import ./fcitx5.nix {
        inherit (packages)
          fcitx5-unikey
          fcitx5-tokyonight
          ;
      };
    }
    {
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.fcitx5-with-addons = packages.fcitx5-with-addons;
        fcitx5.waylandFrontend = common.hyprland.enable;
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
