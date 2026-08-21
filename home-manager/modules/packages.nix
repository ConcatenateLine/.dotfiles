{ pkgs, pkgsLvim, ... }:

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

    # LunarVim prerequisites (installer + treesitter builds)
    gnumake python3 nodejs rustc gcc

    # Neovim pinned to 0.10.x for LunarVim nightly compatibility
    pkgsLvim.neovim
  ];
}
