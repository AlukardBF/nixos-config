{ pkgs, config, lib, inputs, ... }:
let
  # mozilla_overlay = import inputs.nixpkgs-mozilla;
  system = "x86_64-linux";
  old = import inputs.nixpkgs-old ({
    config = config.nixpkgs.config;
    localSystem = { inherit system; };
  });
in
{
  nixpkgs.overlays = [
    # inputs.nix.overlay
    # mozilla_overlay
    (self: super:
      rec {
        # nix = super.nix // {
        #   meta = super.nix.meta // { platforms = lib.platforms.unix; };
        # };
        inherit inputs;

        youtube-to-mpv = pkgs.callPackage ./packages/youtube-to-mpv.nix { term = config.defaultApplications.term.cmd; };
        wg-conf = pkgs.callPackage ./packages/wg-conf.nix { };
        i3lock-fancy-rapid = pkgs.callPackage ./packages/i3lock-fancy-rapid.nix { };
        xonar-fp = pkgs.callPackage ./packages/xonar-fp.nix { };
        advance-touch = pkgs.callPackage ./packages/advance-touch.nix { };
        nomino = pkgs.callPackage ./packages/nomino.nix { };
        bpytop = pkgs.callPackage ./packages/bpytop.nix { };
        ibm-plex-powerline = pkgs.callPackage ./packages/ibm-plex-powerline.nix { };
        # vivaldi = old.vivaldi;
        # material-icons = pkgs.callPackage ./packages/material-icons-inline.nix { };
        # rust-stable = pkgs.latest.rustChannels.stable.rust.override {
        #   extensions = [
        #     "rls-preview"
        #     "clippy-preview"
        #     "rustfmt-preview"
        #   ];
        # };
        # wpgtk = super.wpgtk.overrideAttrs (old: rec {
        # 	propagatedBuildInputs = with pkgs; [
        #     python2 python27Packages.pygtk
        #     python3Packages.pygobject3 python3Packages.pillow python3Packages.pywal
        #   ];
        # });
        # spotifyd = super.spotifyd.override { withPulseAudio = true; };
        # spotify-tui = naersk.buildPackage {
        #   name = "spotify-tui";
        #   src = pkgs.imports.spotify-tui;
        #   buildInputs = [ pkgs.pkgconf pkgs.openssl ];
        # };
      }
    )
  ];

  nixpkgs.config = {
    allowUnfree = true;
    android_sdk.accept_license = true;
  };

  environment.etc.nixpkgs.source = inputs.nixpkgs;

  nix = rec {
    useSandbox = true;

    autoOptimiseStore = config.deviceSpecific.isSSD;

    optimise.automatic = true;

    nixPath = lib.mkForce [
      "nixpkgs=/etc/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
    ];

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # TODO: change?
    package = pkgs.nixFlakes;
    # package = inputs.nix.packages.x86_64-linux.nix;

    registry.self.flake = inputs.self;
  };
}
