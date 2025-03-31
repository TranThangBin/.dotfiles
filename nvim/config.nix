{ lib, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> { };

  fromGitHub =
    ref: repo:
    pkgsUnstable.vimUtils.buildVimPlugin {
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
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgsUnstable.vimPlugins; [
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
      (nvim-treesitter.withPlugins (p: [
        p.c
        p.cpp
        p.go
        p.rust
        p.zig
        p.lua
        p.nix
        p.bash
        p.html
        p.css
        p.javascript
        p.typescript
        p.python
        p.svelte
        p.templ
        p.gdscript
        p.json
        p.yaml
        p.toml
        p.gitcommit
        p.prolog
      ]))
      (fromGitHub "main" "eduardo-antunes/plainline")
    ];
    extraPackages = with pkgsUnstable; [
      pyright
      ruff
      nixd
      nixfmt-rfc-style
      lua-language-server
      stylua
      ccls
      prettierd
      vscode-langservers-extracted
      emmet-language-server
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
      tree-sitter
      gdtoolkit_4
    ];
  };
}
