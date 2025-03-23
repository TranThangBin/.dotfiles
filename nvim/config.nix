{ pkgs, lib, ... }:
let
  fromGitHub =
    ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };
in
{
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
      catppuccin-nvim
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
      vim-fugitive
      telescope-fzf-native-nvim
      todo-comments-nvim
      fidget-nvim
      gitsigns-nvim
      trouble-nvim
      zen-mode-nvim
      vim-be-good
      none-ls-nvim
      nvim-treesitter-textobjects
      nvim-treesitter-context
      (nvim-treesitter.withPlugins (
        p: with p; [
          c
          cpp
          go
          rust
          zig
          lua
          nix
          bash
          html
          css
          javascript
          typescript
          python
          svelte
          templ
          gdscript
          json
          yaml
          toml
          gitcommit
        ]
      ))
      (fromGitHub "main" "eduardo-antunes/plainline")
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
      taplo
      gopls
      dockerfile-language-server-nodejs
      docker-compose-language-service
      bash-language-server
      shfmt
      svelte-language-server
      rust-analyzer
      zls
      python312Packages.python-lsp-server
      tree-sitter
      gdtoolkit_4
    ];
  };
}
