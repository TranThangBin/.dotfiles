{ config, pkgs, ... }:
let
  HOME = config.home.homeDirectory;
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = "[ -z $TMUX ] && ${pkgs.fastfetch}/bin/fastfetch";
    shellAliases = {
      home-manager = "${pkgs.home-manager}/bin/home-manager -f ${config.home.homeDirectory}/.dotfiles/home.nix";
      Docker-start = "systemctl start --user docker";
      Docker-stop = "systemctl stop --user docker";
      Docker-restart = "systemctl restart --user docker";
    };
    envExtra = ''
      export DOCKER_HOST=unix://${builtins.getEnv "XDG_RUNTIME_DIR"}/docker.sock
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      export PATH=${HOME}/go/bin:${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:${builtins.getEnv "PATH"}
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
