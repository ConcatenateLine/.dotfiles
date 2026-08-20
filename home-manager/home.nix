{ config, pkgs, ... }:

{
  imports = [
    ./modules/packages.nix
    ./modules/programs.nix
  ];

  home.username = "ubuntuuser";
  home.homeDirectory = "/home/ubuntuuser";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
