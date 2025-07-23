let
  catppuccin-mocha = import ../catppuccin-mocha.nix;
  base = catppuccin-mocha.base;
  text = catppuccin-mocha.text;
  textAlpha = catppuccin-mocha.textAlpha;
  accent = catppuccin-mocha.mauve;
  accentAlpha = catppuccin-mocha.mauveAlpha;
  surface0 = catppuccin-mocha.surface0;
  red = catppuccin-mocha.red;
  yellow = catppuccin-mocha.yellow;
  font = "FiraMono Nerd Font Mono";
in
{
  settings = {
    general = {
      disable_loading_bar = true;
      hide_cursor = true;
    };

    background = {
      monitor = "";
      path = "${./hyprlock-Mountain_Sunset.png}";
      blur_passes = 0;
      color = base;
    };

    label = [
      {
        monitor = "";
        text = "Layout: $LAYOUT";
        color = text;
        font_size = 25;
        font_family = font;
        position = "30, -30";
        halign = "left";
        valign = "top";
      }

      {
        monitor = "";
        text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
        color = text;
        font_size = 25;
        font_family = font;
        position = "-30, -150";
        halign = "right";
        valign = "top";
      }

      {
        monitor = "";
        text = "$TIME";
        color = text;
        font_size = 90;
        font_family = font;
        position = "-30, 0";
        halign = "right";
        valign = "top";
      }
    ];

    "" = {
      monitor = "";
      text = "$FPRINTPROMPT";
      color = text;
      font_size = 14;
      font_family = font;
      position = "0, -107";
      halign = "center";
      valign = "center";
    };

    image = {
      monitor = "";
      path = "${./hyprlock-Go_Gopher.webp}";
      size = 100;
      border_color = accent;
      position = "0, 75";
      halign = "center";
      valign = "center";
    };

    input-field = {
      monitor = "";
      size = "300, 60";
      outline_thickness = 4;
      dots_size = 0.2;
      dots_spacing = 0.2;
      dots_center = true;
      outer_color = accent;
      inner_color = surface0;
      font_color = text;
      fade_on_empty = false;
      placeholder_text = ''<span foreground="##${textAlpha}"><i>󰌾 Logged in as </i><span foreground="##${accentAlpha}">$USER</span></span>'';
      hide_input = false;
      check_color = accent;
      fail_color = red;
      fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
      capslock_color = yellow;
      position = "0, -47";
      halign = "center";
      valign = "center";
    };
  };
}
