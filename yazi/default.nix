{ config, pkgs, ... }:
let
  yaziPlugins = builtins.fetchGit {
    url = "https://github.com/yazi-rs/plugins.git";
    ref = "main";
  };
  yaziFlavors = builtins.fetchGit {
    url = "https://github.com/yazi-rs/flavors.git";
    ref = "main";
  };
  yaziYatline = builtins.fetchGit {
    url = "https://github.com/imsi32/yatline.yazi.git";
    ref = "main";
  };
  yaziYatlineCatppuccin = builtins.fetchGit {
    url = "https://github.com/imsi32/yatline-catppuccin.yazi.git";
    ref = "main";
  };
  yaziRelativeMotion = builtins.fetchGit {
    url = "https://github.com/dedukun/relative-motions.yazi.git";
    ref = "main";
  };
in
{
  programs.yazi = {
    enableZshIntegration = true;
    initLua = ./init.lua;
    plugins = {
      git = "${yaziPlugins}/git.yazi";
      toggle-pane = "${yaziPlugins}/toggle-pane.yazi";
      diff = "${yaziPlugins}/diff.yazi";
      chmod = "${yaziPlugins}/chmod.yazi";
      mime-ext = "${yaziPlugins}/mime-ext.yazi";
      jump-to-char = "${yaziPlugins}/jump-to-char.yazi";
      smart-enter = "${yaziPlugins}/smart-enter.yazi";
      smart-filter = "${yaziPlugins}/smart-filter.yazi";
      vcs-files = "${yaziPlugins}/vcs-files.yazi";
      piper = "${yaziPlugins}/piper.yazi";
      yatline = "${yaziYatline}";
      yatline-catppuccin = "${yaziYatlineCatppuccin}";
      relative-motions = "${yaziRelativeMotion}";
    };
    settings = {
      manager = {
        ratio = [
          0
          4
          6
        ];
      };
      preview = {
        max_width = 1500;
        max_height = 1000;
      };
      opener = {
        play = [
          {
            run = ''${pkgs.vlc}/bin/vlc "$@"'';
            orphan = true;
            for = "unix";
          }
        ];
        edit = [
          {
            run = ''${config.programs.neovim.finalPackage}/bin/nvim "$@"'';
            block = true;
            for = "unix";
          }
        ];
      };
      plugin = {
        append_previewers = [
          {
            name = "*";
            run = ''piper -- ${pkgs.hexyl}/bin/hexyl --border=none --terminal-width=$w "$1"'';
          }
        ];
        prepend_previewers = [
          {
            name = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 ${pkgs.glow}/bin/glow -w=$w -s=dark "$1"'';
          }
          {
            name = "*/";
            run = ''piper -- ${pkgs.eza}/bin/eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
        ];
        prepend_fetchers = [
          {
            id = "git";
            name = "*";
            run = "git";
          }
          {
            id = "git";
            name = "*/";
            run = "git";
          }
          {
            id = "mime";
            name = "*";
            run = "mime-ext";
            prio = "high";
          }
        ];
      };
    };
    keymap = {
      manager = {
        prepend_keymap = [
          {
            on = "<C-t>";
            run = "tab_create --current";
            desc = "Create a new tab with CWD";
          }
          {
            on = "<C-c>";
            run = "noop";
          }
          {
            on = "<C-w>";
            run = "close";
            desc = "Close the current tab, or quit if it's last";
          }
          {
            on = "t";
            run = "plugin toggle-pane max-current";
            desc = "Maximize or restore the current pane";
          }
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = "<C-d>";
            run = "plugin diff";
            desc = "Diff the selected with the hovered file";
          }
          {
            on = [
              "c"
              "m"
            ];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = "f";
            run = "plugin jump-to-char";
            desc = "Jump to char";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
          {
            on = [
              "g"
              "c"
            ];
            run = "plugin vcs-files";
            desc = "Show Git file changes";
          }
          {
            on = "M";
            run = "plugin relative-motions";
            desc = "Trigger a new relative motion";
          }
        ];
      };
    };
    flavors = {
      catppuccin-frappe = "${yaziFlavors}/catppuccin-frappe.yazi";
      catppuccin-latte = "${yaziFlavors}/catppuccin-latte.yazi";
      catppuccin-macchiato = "${yaziFlavors}/catppuccin-macchiato.yazi";
      catppuccin-mocha = "${yaziFlavors}/catppuccin-mocha.yazi";
      dracula = "${yaziFlavors}/dracula.yazi";
    };
    theme.flavor = {
      light = "catppuccin-mocha";
      dark = "catppuccin-mocha";
    };
  };
}
