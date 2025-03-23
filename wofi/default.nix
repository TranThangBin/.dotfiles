{ pkgs, ... }:
{
  home.file.".local/bin/wofi.sh" = {
    executable = true;
    text = with pkgs; ''
      #! /usr/bin/bash

      if [[ ! $(pidof ${wofi}/bin/wofi) ]]; then
        ${wofi}/bin/wofi
      else
        pkill ${wofi}/bin/wofi
      fi
    '';
  };

  xdg.configFile."wofi/style.css".source = "${./style.css}";

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
