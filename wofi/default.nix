{ pkgs, ... }:
let
  utils = import ../utils.nix;
in
{
  home.file.".local/bin/wofi.sh" = {
    enable = utils.HYPRLAND_AVAILABLE;
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

  xdg.configFile."wofi/style.css" = {
    enable = utils.HYPRLAND_AVAILABLE;
    source = "${./style.css}";
  };

  programs.wofi = {
    enable = utils.HYPRLAND_AVAILABLE;
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
