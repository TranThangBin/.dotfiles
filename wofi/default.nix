let
  pkgsUnstable = import <nixpkgs-unstable> { };
in
{
  programs.wofi = {
    style = builtins.readFile ./style.css;
    settings = {
      show = "drun";
      width = 750;
      height = 400;
      always_parse_args = true;
      show_all = false;
      term = "${pkgsUnstable.ghostty}/bin/ghostty";
      hide_scroll = true;
      print_command = true;
      insensitive = true;
      prompt = "";
      columns = 2;
    };
  };
}
