let
  steamGames = {
    "322170" = "Geometry Dash";
    "1449850" = "Yu-Gi-Oh!  Master Duel";
    "1903340" = "Clair Obscur: Expedition 33";
    "582010" = "Monster Hunter: World";
    "1899060" = "Pocket Mirror ~ GoldenerTraum";
  };
in
builtins.listToAttrs (
  builtins.map (gameID: {
    name = gameID;
    value = {
      name = steamGames.${gameID};
      comment = "Play this game on Steam";
      exec = "steam steam://rungameid/${gameID}";
      icon = "steam_icon_${gameID}";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
      prefersNonDefaultGPU = true;
    };
  }) (builtins.attrNames steamGames)
)
