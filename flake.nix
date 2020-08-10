{
  description = "System configuration";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager.url = github:rycee/home-manager/bqv-flakes;
    base16.url = github:alukardbf/base16-nix/custom-scheme;
    # base16.url = "/shared/nixos/base16-nix";
    base16-horizon-scheme = {
      url = github:michael-ball/base16-horizon-scheme;
      flake = false;
    };
    materia-theme = {
      url = github:nana-4/materia-theme;
      flake = false;
    };
    zsh-autosuggestions = {
      url = github:zsh-users/zsh-autosuggestions;
      flake = false;
    };
    zsh-nix-shell = {
      url = github:chisui/zsh-nix-shell;
      flake = false;
    };
    zsh-you-should-use = {
      url = github:MichaelAquilina/zsh-you-should-use;
      flake = false;
    };
    i3lock-fancy-rapid = {
      url = github:yvbbrjdr/i3lock-fancy-rapid;
      flake = false;
    };
    spotify-tui = {
      url = github:Rigellute/spotify-tui;
      flake = false;
    };
    nixpkgs-mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };
  };

  outputs = { nixpkgs, nix, self, ... }@inputs: {
    nixosConfigurations = with nixpkgs.lib;
      let
        hosts = map (fname: builtins.head (builtins.match "(.*)\\.nix" fname))
          (builtins.attrNames (builtins.readDir ./hardware-configuration));
        mkHost = name:
          nixosSystem {
            system = "x86_64-linux";
            modules = [ (import ./default.nix) ];
            specialArgs = { inherit inputs name; };
          };
      in genAttrs hosts mkHost;

    legacyPackages.x86_64-linux =
      (builtins.head (builtins.attrValues self.nixosConfigurations)).pkgs;
  };
}
