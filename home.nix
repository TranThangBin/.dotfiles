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

    preferedWallpaper = ./wallpapers/Snow-valley.jpg;
    preferedVideopaper = "https://youtu.be/YhUPi6-MQNE?si=zS7PKwOmwxQeGQhf";
    umuConfigDir = "${gamesDir}/umu/config";
    gamesDir = "${config.home.homeDirectory}/Games";
    hyprlandEnabled = config.wayland.windowManager.hyprland.enable;
    waylandSystemdTarget = config.wayland.systemd.target;
    kittyBackgroundOpacity = config.programs.kitty.settings.background_opacity;
    ghosttyBackgroundOpacity = config.programs.ghostty.settings.background-opacity;
  };

  scripts = builtins.mapAttrs (name: value: common.homeDirectory + "/" + value) (
    let
      file = config.home.file;
    in
    {
      minecraftScript = file.".local/bin/run-minecraft.sh".target;
      wofiScript = file.".local/bin/run-wofi-uwsm-wrapped.sh".target;
      clipboardPickerScript = file.".local/bin/run-clipboard-picker.sh".target;
      clipboardDeleteScript = file.".local/bin/run-clipboard-delete.sh".target;
      clipboardWipeScript = file.".local/bin/run-clipboard-wipe.sh".target;
    }
  );

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
        "/usr/bin/pkill"
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
      java = java.package;
      wofi = wofi.package;
    })
    // (with config.services; {
      easyeffects = easyeffects.package;
      swaync = swaync.package;
      podman = podman.package;
      playerctl = playerctld.package;
      swayosd = swayosd.package;
      cliphist = cliphist.package;
    })
    // (with pkgs; {
      inherit
        corefonts
        nerd-fonts
        noto-fonts
        noto-fonts-cjk-serif
        noto-fonts-cjk-sans
        noto-fonts-color-emoji

        podman-compose
        hexyl
        glow
        eza
        systemd
        xdg-desktop-portal
        xdg-desktop-portal-termfilechooser
        pipewire
        wireplumber
        helvum
        pwvucontrol
        openal
        ncdu
        wl-clipboard
        brightnessctl
        fcitx5-unikey
        fcitx5-tokyonight
        umu-launcher-unwrapped
        uwsm
        wev
        imagemagick
        exiftool
        ueberzugpp
        hyprpicker
        wofi-emoji
        hyprshot
        alsa-utils
        alsa-tools
        alsa-lib
        alsa-plugins
        scrcpy

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
        jetbrains

        nur
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
      brave = common.wrapOffload brave;
      hyprsysteminfo = common.wrap hyprsysteminfo;
      obs-studio = common.wrapOffload obs-studio;
      discord = common.wrapOffload discord;
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
  home.sessionVariables.DOTFILES_DIR = "${common.homeDirectory}/.dotfiles";
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.hyprcursor.enable = common.hyprlandEnabled;
  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 28;
  };
  home.shellAliases.docker = "${packages.podman}/bin/podman";
  home.sessionVariables = {
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    PODMAN_COMPOSE_PROVIDER = "${packages.podman-compose}/bin/podman-compose";
  };
  home.packages =
    with packages;
    let
      hyprlandExtra = lib.lists.optionals common.hyprlandEnabled [
        wev
        uwsm
        hyprshot
        hyprpicker
        wofi-emoji
        wl-clipboard
        hyprsysteminfo
      ];
      yaziExtra = lib.lists.optionals config.programs.yazi.enable [
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
      builtins.map (
        scriptFile:
        let
          dependencies = with packages; {
            "minecraft.sh" = [
              "${openal}/lib/libopenal.so.1"
              "${java}/bin/java"
              "${legacyLauncher}"
            ];
            "wofi-uwsm-wrapped.sh" = [
              "${wofi}/bin/wofi"
              "${uwsm}/bin/uwsm-app"
            ];
            "clipboard-picker.sh" = [
              "${cliphist}/bin/cliphist"
              "${wofi}/bin/wofi"
              "${wl-clipboard}/bin/wl-copy"
            ];
            "clipboard-delete.sh" = [
              "${cliphist}/bin/cliphist"
              "${wofi}/bin/wofi"
            ];
            "clipboard-wipe.sh" = [
              "${wofi}/bin/wofi"
              "${cliphist}/bin/cliphist"
            ];
            "unitynvim.sh" = [
              "${neovim}/bin/nvim"
              "${neovide}/bin/neovide"
            ];
          };
        in
        [
          {
            ".local/bin/${scriptFile}" = {
              executable = true;
              source = "${./scripts}/${scriptFile}";
            };
          }
          {
            ".local/bin/run-${scriptFile}" = {
              executable = true;
              text = ''
                #!/usr/bin/env bash
                ${common.homeDirectory}/${config.home.file.".local/bin/${scriptFile}".target} \
                    ${builtins.concatStringsSep " " dependencies.${scriptFile}} "$@"
              '';
            };
          }
        ]
      ) (builtins.attrNames (builtins.readDir ./scripts))
    )
  );

  programs = common.mkMerge [
    {
      hyprlock.enable = common.hyprlandEnabled;
      waybar.enable = common.hyprlandEnabled;
      wofi.enable = common.hyprlandEnabled;
      wlogout.enable = common.hyprlandEnabled;
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
      hyprlock.package = pkgs.emptyDirectory; # Manage hyprlock with your os package manager
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
      swaync.enable = common.hyprlandEnabled;
      cliphist.enable = common.hyprlandEnabled;
      hyprpaper.enable = common.hyprlandEnabled;
      hypridle.enable = common.hyprlandEnabled;
      hyprsunset.enable = common.hyprlandEnabled;
      swayosd.enable = common.hyprlandEnabled;
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
    if common.hyprlandEnabled then
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
        config = lib.mkIf common.hyprlandEnabled {
          common = {
            default = [ "hyprland" ];
            "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
          };
          hyprland.default = [ "hyprland" ];
        };
        extraPortals = with packages; [ xdg-desktop-portal-termfilechooser ];
      };
      configFile = {
        "uwsm/env".enable = common.hyprlandEnabled;
        "uwsm/env-hyprland".enable = common.hyprlandEnabled;
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
        fcitx5.fcitx5-with-addons = pkgs.fcitx5-with-addons;
        fcitx5.waylandFrontend = common.hyprlandEnabled;
      };
    }
  ];

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
}
