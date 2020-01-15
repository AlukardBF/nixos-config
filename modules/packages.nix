{ pkgs, config, lib, ... }:
let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
in {
  nixpkgs.overlays = [
    moz_overlay
    (self: old: rec {
      # nerdfonts = nur.balsoft.pkgs.roboto-mono-nerd;
      youtube-to-mpv = pkgs.callPackage ./applications/youtube-to-mpv.nix {};
      wg-conf = pkgs.callPackage ./applications/wg-conf.nix {};
      podman-compose = pkgs.callPackage ./applications/podman-compose.nix {};
      xonar-fp = pkgs.writers.writeBashBin "xonar-fp" ''
        CURRENT_STATE=`amixer -c 0 sget "Front Panel" | egrep -o '\[o.+\]'`
        if [[ $CURRENT_STATE == '[on]' ]]; then
            amixer -c 0 sset "Front Panel" mute
        else
            amixer -c 0 sset "Front Panel" unmute
        fi
      '';
    })
    (self: super: {
      vscode-with-extensions = super.vscode-with-extensions.override {
        # When the extension is already available in the default extensions set.
        vscodeExtensions = with super.vscode-extensions; [
          bbenoist.Nix
        ] ++ super.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "vscode-remote-extensionpack";
            publisher = "ms-vscode-remote";
            version = "0.17.0";
            sha256 = "Dlf9RzNefPilnbezh13C+WAsTJ7GqSCMEhnWhER+u5s=";
          }
        ];
      };

    })
  ];
  nixpkgs.config = {
    packageOverrides = pkgs: {
      i3lock-fancy = pkgs.callPackage ./applications/i3lock-fancy.nix {};
      git-with-libsecret = pkgs.git.override { withLibsecret = true; };
    };
  };
}