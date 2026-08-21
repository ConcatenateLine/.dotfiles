{ config, pkgs, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/programs.nix
    ./modules/dotfiles.nix
  ];

  home.username = "ubuntuuser";
  home.homeDirectory = "/home/ubuntuuser";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
