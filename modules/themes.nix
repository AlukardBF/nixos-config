{ config, lib, pkgs, inputs, ... }:
with lib;
# let
#   fromBase16 = base16scheme:
#     builtins.mapAttrs (_: v: "#" + v) {
#       bg = base00-hex;
#       # fg = base07-hex;
#       fg = base05-hex;
#     };
# in
{
  # options = {
  #   themes = {
  #     colors = mkOption {
  #       description =
  #         "Set of colors from which the themes for various applications will be generated";
  #       type = with types;
  #         submodule {

  #           options = let
  #             colors = (builtins.genList (x: (toString x) ) 15);
  #           in {
  #             bg = types.str;
  #             fg = types.str;
  #           } // builtins.listToAttrs (builtins.map (x: {
  #             name = "base${x}";
  #             value = types.str;
  #           }) colors);
  #         };
  #     };
  #   };
  # };
  config.themes.base16 = {
    enable = true;
    customScheme = {
      enable = true;
      path = "${inputs.base16-horizon-scheme}/horizon-dark.yaml";
    };
    # scheme = "gruvbox";
    # variant = "gruvbox-dark-medium";
    extraParams = {
      font = "IBM Plex Sans";
      fontMono = "IBM Plex Mono";
      fontSerif = "IBM Plex Serif";
      fallbackFont = "Roboto";
      fallbackFontMono = "Roboto Mono";
      fallbackFontSerif = "Roboto Slab";
      powerlineFont = "IBM Plex Mono for Powerline";
      fontSize = "12";
      headerSize = "14";
      iconFont = "Font Awesome 5 Free";
      fallbackIcon = "Material Icons";
      iconsTheme = "Papirus-Dark";
    };
  };
}