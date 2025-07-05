{
  config,
  lib,
  pkgs,
  yaziFlavors,
  ...
}:
let
  hyprland = config.wayland.windowManager.hyprland;
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
          Icon=${./desktop-icons/Ncdu.png}
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
            wrapFn = config.lib.nixGL.wrapOffload;
          }
          {
            name = "obs-studio";
            wrapFn = config.lib.nixGL.wrapOffload;
          }
          {
            name = "discord";
            wrapFn = config.lib.nixGL.wrapOffload;
          }
        ]
        ++ lib.lists.optionals hyprland.enable [
          "uwsm"
          "wev"
          "hyprshot"
          "hyprpicker"
          "wofi-emoji"
          "wl-clipboard"
          {
            name = "hyprsysteminfo";
            wrapFn = config.lib.nixGL.wrap;
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

  programs = import ./programs {
    hyprlandEnabled = config.wayland.windowManager.hyprland.enable;
    fastfetch = config.programs.fastfetch.package;
    zsh = config.programs.zsh.package;
    btop = config.programs.btop.package;
    yazi = config.programs.yazi.package;
    wlogout = config.programs.wlogout.package;
    firefox = config.lib.nixGL.wrapOffload pkgs.firefox;
    kitty = config.lib.nixGL.wrap pkgs.kitty;
    ghostty = config.lib.nixGL.wrap pkgs.ghostty;
    mpv = config.lib.nixGL.wrapOffload pkgs.mpv;
    mpvpaper = config.lib.nixGL.wrapOffload pkgs.mpvpaper;
    neovide = config.lib.nixGL.wrap pkgs.neovide;
    easyeffects = config.services.easyeffects.package;
    swaync = config.services.swaync.package;
    playerctl = config.services.playerctld.package;
    neovimFinal = config.programs.neovim.finalPackage;
    firefoxFinal = config.programs.firefox.finalPackage;
    inherit yaziFlavors;
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
    inherit (pkgs)
      emptyDirectory
      nur
      hexyl
      glow
      eza
      yaziPlugins
      toybox
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
  };

  systemd.user.systemctlPath = "${config.lib.packages.systemd}/bin/systemctl";

  targets.genericLinux.enable = true;

  xdg.portal.enable = true;

  xdg.userDirs.enable = true;

  fonts.fontconfig.enable = true;

  home.pointerCursor.gtk.enable = true;

  home.pointerCursor = {
    name = "Dracula-cursors";
    package = pkgs.dracula-theme;
    size = 28;
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null; # Manage hyprland with your os package manager

  services.swaync.enable = hyprland.enable;
  services.cliphist.enable = hyprland.enable;
  services.hyprpaper.enable = hyprland.enable;
  services.hypridle.enable = hyprland.enable;
  services.hyprsunset.enable = hyprland.enable;
  # services.xembed-sni-proxy.enable = hyprland.enable;

  services.playerctld.enable = true;
  services.psd.enable = true;
  services.podman.enable = true;
  services.easyeffects.enable = true;
  services.poweralertd.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  xdg.configFile."systemd/user/network-manager-applet.service.d/override.conf".enable =
    config.services.network-manager-applet.enable;
  xdg.configFile."systemd/user/hyprpaper.service.d/override.conf".enable =
    config.services.hyprpaper.enable;
  xdg.configFile."systemd/user/dconf.service.d/override.conf".enable = config.dconf.enable;

  xdg.configFile."systemd/user/network-manager-applet.service.d/override.conf".text = ''
    [Service]
    Restart=on-failure
  '';
  xdg.configFile."systemd/user/hyprpaper.service.d/override.conf".text = ''
    [Unit]
    Conflicts=mpvpaper.service
  '';
  xdg.configFile."systemd/user/dconf.service.d/override.conf".text = ''
    [Install]
    WantedBy=default.target
  '';

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.glibcLocales = pkgs.glibcLocales.override {
    locales = [ "en_US.UTF-8/UTF-8" ];
  };

  qt.enable = true;
  gtk.enable = true;

  services.poweralertd.extraArgs = [
    "-s"
    "-S"
  ];

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
    ./mozilla
    ./nvim
    ./hyprland
    ./audio
    ./games
    ./container.nix
    ./fonts.nix
    ./fcitx5.nix
    ./xdg-desktop-portal.nix
    ./mpvpaper.nix
  ];
}
