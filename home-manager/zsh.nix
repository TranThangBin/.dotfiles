{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = "[ -z $TMUX ] && fastfetch";
    envExtra = ''
      export ZSH=$HOME/.nix-profile/share/oh-my-zsh
      export PATH=$HOME/go/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:${
        builtins.getEnv "PATH"
      }
    '';
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "tmux" "vi-mode" "command-not-found" ];
      extraConfig = ''
        bindkey '^ ' autosuggest-accept
      '';
    };
  };
}
