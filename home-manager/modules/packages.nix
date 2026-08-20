{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Core CLI
    git delta diff-so-fancy
    fzf ripgrep bat eza jq
    curl wget unzip tree htop

    # Languages (nvm/mise stay alongside for version switching)
    go
    docker-compose

    # Utilities
    lazygit
  ];
}
