{ config, pkgs, ... }:
{
  programs.neovide.enable = true;
  programs.neovide.package = config.lib.nixGL.wrap pkgs.neovide;

  programs.neovim = {
    defaultEditor = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-obsession
      telescope-nvim
      telescope-fzf-native-nvim
      harpoon2
      rose-pine
      tokyonight-nvim
      catppuccin-nvim
      nvim-lspconfig
      SchemaStore-nvim
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      friendly-snippets
      lspkind-nvim
      lazydev-nvim
      luvit-meta
      undotree
      vim-godot
      netrw-nvim
      nvim-autopairs
      nvim-ts-autotag
      nvim-surround
      oil-nvim
      vim-fugitive
      todo-comments-nvim
      fidget-nvim
      gitsigns-nvim
      trouble-nvim
      zen-mode-nvim
      vim-be-good
      none-ls-nvim
      nvim-treesitter-textobjects
      nvim-treesitter-context
      ccc-nvim
      cloak-nvim
      vim-dadbod
      vim-dadbod-completion
      vim-dadbod-ui
      hardtime-nvim
      (nvim-treesitter.withPlugins (p: [
        p.c
        p.cpp
        p.c-sharp
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
      plainline
      tailwindcss-colorizer-cmp-nvim
    ];
    extraPackages = with pkgs; [
      pyright
      ruff
      nil
      nixfmt-rfc-style
      lua-language-server
      roslyn-ls
      stylua
      ccls
      prettierd
      vscode-langservers-extracted
      emmet-language-server
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
