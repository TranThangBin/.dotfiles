{
  fastfetch,
  sudoBin,
  mktempBin,
}:
{
  oh-my-zsh.enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  initContent = ''
    [ -z $TMUX ] && ${fastfetch}/bin/fastfetch
  '';

  history = {
    ignoreAllDups = true;
    ignoreSpace = true;
    ignorePatterns = [
      "clear"
      "sudo *"
    ];
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
}
