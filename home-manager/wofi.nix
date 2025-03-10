{ config, pkgs, ... }:
{
  home.file.".local/bin/wofi.sh" = {
    executable = true;
    text = ''
      #! /usr/bin/bash

      if [[ ! $(pidof ${pkgs.wofi}/bin/wofi) ]]; then
        ${pkgs.wofi}/bin/wofi
      else
        pkill ${pkgs.wofi}/bin/wofi
      fi
    '';
  };

  xdg.configFile."wofi/style.css".source = "${config.home.homeDirectory}/.dotfiles/wofi/style.css";

  programs.wofi = {
    enable = true;
    settings = {
      show = "drun";
      width = 750;
      height = 400;
      always_parse_args = true;
      show_all = false;
      term = "ghostty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "";
      columns = 2;
    };
  };
}
