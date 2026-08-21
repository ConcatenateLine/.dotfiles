{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Pinned older nixpkgs: neovim 0.10.x required by LunarVim nightly
    # (unstable ships 0.12, which LunarVim does not support).
    nixpkgs-lvim.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-lvim, home-manager, ... }: {
    homeConfigurations."ubuntuuser" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs.pkgsLvim = nixpkgs-lvim.legacyPackages.x86_64-linux;
      modules = [ ./home.nix ];
    };
  };
}
