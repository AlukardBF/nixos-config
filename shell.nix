{ pkgs ? import <nixpkgs> { } }:
let
  configs = "${toString ./.}#nixosConfigurations";
  build = "config.system.build";

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    if [[ -z $1 ]]; then
      echo "Usage: $(basename $0) host {switch|boot|test}"
    else
      sudo -E nix shell -vv ${configs}.$1.${build}.toplevel -c switch-to-configuration $2
    fi
  '';
in
pkgs.mkShell {
  name = "nixflk";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixFlakes
    rebuild
    gnupg
  ];

  shellHook = ''
    PATH=${
      pkgs.writeShellScriptBin "nix" ''
        ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes ca-references" "$@"
      ''
    }/bin:$PATH
  '';
}
