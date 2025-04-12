{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };
  mountSmbScript = pkgsUnstable.writeShellScript "mount-smb.sh" ''
    #/usr/bin/env bash

    printf "Enter your address (e.g: //192.168.1.5/share): "
    read -r address

    printf "mount point (e.g: /mnt/share): "
    read -r mount_point

    printf "username: "
    read -r username

    printf "password: "
    read -rs password

    echo
    sudo mount -t cifs "$address" "$mount_point" --mkdir -o username="$username",password="$password"
  '';
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
      mount-smb = "${mountSmbScript}";
    };

    oh-my-zsh = {
      theme = "robbyrussell";
      plugins = [
        "tmux"
        "vi-mode"
        "systemd"
      ];
      extraConfig = ''
        bindkey '^ ' autosuggest-accept
      '';
    };
  };
}
