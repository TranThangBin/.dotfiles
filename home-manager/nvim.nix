{ config, pkgs, lib, ... }:

let
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };
in {
  xdg.configFile.nvim.source = "${config.home.homeDirectory}/.dotfiles/nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      vim-obsession
      telescope-nvim
      harpoon2
      rose-pine
      tokyonight-nvim
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-lspconfig
      SchemaStore-nvim
      lsp-zero-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp_luasnip
      friendly-snippets
      lsp-overloads-nvim
      lazydev-nvim
      luvit-meta
      undotree
      vim-godot
      netrw-nvim
      nvim-autopairs
      nvim-ts-autotag
      nvim-surround
      oil-nvim
      comment-nvim
      nvim-treesitter-context
      vim-fugitive
      telescope-fzf-native-nvim
      todo-comments-nvim
      fidget-nvim
      gitsigns-nvim
      trouble-nvim
      zen-mode-nvim
      none-ls-nvim
    ];
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
      lua-language-server
      stylua
      ccls
      prettierd
      vscode-langservers-extracted
      htmx-lsp
      tailwindcss-language-server
      typescript-language-server
      yaml-language-server
      gopls
      dockerfile-language-server-nodejs
      docker-compose-language-service
    ];
  };
}
