{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  programs.zsh = {
    oh-my-zsh.enable = true;
    oh-my-zsh.package = pkgsUnstable.oh-my-zsh;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = "[ -z $TMUX ] && ${pkgsUnstable.fastfetch}/bin/fastfetch";
    shellAliases = {
      home-manager = "${pkgs.home-manager}/bin/home-manager -f ${config.home.homeDirectory}/.dotfiles/home.nix";
      ds = "${pkgsUnstable.systemd}/bin/systemctl --user start docker";
      dss = "${pkgsUnstable.systemd}/bin/systemctl --user stop docker";
      drs = "${pkgsUnstable.systemd}/bin/systemctl --user restart docker";
      dst = "${pkgsUnstable.systemd}/bin/systemctl --user status docker";
    };

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
