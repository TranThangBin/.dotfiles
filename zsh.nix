{ config, pkgs, ... }:
{
  programs.zsh = {
    oh-my-zsh.enable = true;

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

    envExtra = ''
      export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      export PATH=$PATH:${config.home.homeDirectory}/go/bin
    '';

    oh-my-zsh = {
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
