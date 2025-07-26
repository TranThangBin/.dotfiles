{
  config,
  lib,
  pkgs,
}:
(with config.programs; {
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
  go = go.package;
  eza = eza.package;
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

    systemd
    xdg-desktop-portal
    xdg-desktop-portal-termfilechooser
    pipewire
    wireplumber
    helvum
    pwvucontrol
    openal
    ncdu
    brightnessctl
    fcitx5-with-addons
    fcitx5-unikey
    fcitx5-tokyonight
    umu-launcher-unwrapped
    alsa-utils
    alsa-tools
    alsa-lib
    alsa-plugins
    scrcpy
    toybox

    libgcc
    emptyDirectory
    nix
    templ
    zig
    python3
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
    darkly-qt5
    dracula-theme
    dracula-icon-theme

    libsForQt5
    nur
    nixgl
    yaziPlugins
    tmuxPlugins
    vimPlugins
    pyright
    ruff
    nil
    nixfmt-rfc-style
    roslyn-ls
    csharpier
    lua-language-server
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
  brave = config.lib.nixGL.wrapOffload brave;
  obs-studio = config.lib.nixGL.wrapOffload obs-studio;
  discord = config.lib.nixGL.wrapOffload discord;

  hyprlandExtra = lib.attrsets.optionalAttrs config.wayland.windowManager.hyprland.enable {
    inherit
      hyprland
      wev
      uwsm
      hyprshot
      hyprpicker
      wofi-emoji
      wl-clipboard
      ;
    hyprsysteminfo = config.lib.nixGL.wrap hyprsysteminfo;
  };

  yaziExtra = lib.attrsets.optionalAttrs config.programs.yazi.enable {
    inherit
      imagemagick
      exiftool
      ueberzugpp
      hexyl
      glow
      eza
      wl-clipboard
      ;
  };

  podmanExtra = lib.attrsets.optionalAttrs config.services.podman.enable { inherit podman-compose; };
})
