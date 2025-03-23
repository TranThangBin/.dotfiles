{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = "[ -z $TMUX ] && ${pkgs.fastfetch}/bin/fastfetch";
    shellAliases = {
      home-manager = "${pkgs.home-manager}/bin/home-manager -f ${config.home.homeDirectory}/.dotfiles/home.nix";
      ds = "systemctl start --user docker";
      dss = "systemctl stop --user docker";
      drs = "systemctl restart --user docker";
    };
    envExtra = with config.home; ''
      export DOCKER_HOST=unix://${builtins.getEnv "XDG_RUNTIME_DIR"}/docker.sock
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      export PATH=${homeDirectory}/go/bin:${homeDirectory}/bin:${homeDirectory}/.local/bin:/usr/local/bin:${builtins.getEnv "PATH"}
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "tmux"
        "vi-mode"
      ];
      extraConfig = ''
        bindkey '^ ' autosuggest-accept
      '';
    };
  };
}
