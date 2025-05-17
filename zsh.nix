{ config, pkgs, ... }:
{
  home.shell.enableZshIntegration = config.programs.zsh.enable;

  programs.zsh = {
    oh-my-zsh.enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = "[ -z $TMUX ] && ${config.programs.fastfetch.package}/bin/fastfetch";
    shellAliases = {
      home-manager = "home-manager --flake ${config.home.homeDirectory}/.dotfiles";
      mount-smb = "${pkgs.writeShellScript "mount-smb.sh" ''
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
        sudo -k

        unset address mount_point username password
      ''}";
    };

    oh-my-zsh = {
      theme = "robbyrussell";
      plugins = [
        "tmux"
        "vi-mode"
        "systemd"
        "git"
      ];
      extraConfig = ''
        bindkey '^ ' autosuggest-accept
      '';
    };
  };
}
