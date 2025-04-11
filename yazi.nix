let
  yaziFlavors = builtins.fetchGit {
    url = "https://github.com/yazi-rs/flavors.git";
    ref = "main";
  };
in
{
  programs.yazi = {
    enableZshIntegration = true;
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
