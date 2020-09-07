{ stdenv, fetchurl }:
let
  icons = "https://gist.github.com/draoncc/3c20d8d4262892ccd2e227eefeafa8ef/raw/3e6e12c213fba1ec28aaa26430c3606874754c30/MaterialIcons-Regular-for-inline.ttf";
in stdenv.mkDerivation {
  name = "material-icons-inline";

  src = fetchurl {
    name = "material-icons-inline";
    url = icons;
    sha256 = "sha256-huy/En0YX6bkJmrDazxPltsWZOUPxGuQs12r6L+h+oA=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp $src $out/share/fonts/truetype/MaterialIcons-Regular-for-inline.ttf
  '';

  meta = with stdenv.lib; {
    description = "Material Icons Font patched for inline";
  };
}