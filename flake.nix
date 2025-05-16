{
  description = "Home Manager configuration of trant";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixgl.url = "github:nix-community/nixGL";
    darkly.url = "github:Bali10050/Darkly";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plainline = {
      url = "github:eduardo-antunes/plainline";
      flake = false;
    };
    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixgl,
      nur,
      yazi-flavors,
      plainline,
      darkly,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nur.overlays.default
          nixgl.overlay
          (self: super: {
            Darkly-qt5 = darkly.packages."${system}".darkly-qt5;
            vimPlugins = super.vimPlugins // {
              Plainline = super.vimUtils.buildVimPlugin {
                pname = "plainline";
                version = "unstable";
                src = plainline;
              };
            };
          })
        ];
      };
      yaziFlavors = {
        catppuccin-frappe = "${yazi-flavors.outPath}/catppuccin-frappe.yazi";
        catppuccin-latte = "${yazi-flavors.outPath}/catppuccin-latte.yazi";
        catppuccin-macchiato = "${yazi-flavors.outPath}/catppuccin-macchiato.yazi";
        catppuccin-mocha = "${yazi-flavors.outPath}/catppuccin-mocha.yazi";
        dracula = "${yazi-flavors.outPath}/dracula.yazi";
      };
    in
    {
      homeConfigurations."trant" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit yaziFlavors;
        };
      };
    };
}
