{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core CLI
    git delta diff-so-fancy
    fzf ripgrep bat eza jq
    curl wget unzip tree htop

    # Languages
    go
    docker-compose

    # Utilities
    lazygit

    # Editors / version managers (replaces manual curl installs)
    mise
    opencode

    # LazyVim prerequisites (treesitter parser builds)
    gnumake python3 nodejs rustc gcc

    # LazyVim: tree-sitter CLI (nvim-treesitter main branch) + fd (file finding)
    tree-sitter fd

    # Neovim (LazyVim requires >= 0.11.2; unstable ships 0.12.x)
    neovim
  ];
}
