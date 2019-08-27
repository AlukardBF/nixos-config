
{ config, lib, pkgs, ... }:
{
  home-manager.users.alukard = {
    xresources.properties = with config.themes.colors; {
      "*background" = bg;
      "*foreground" = fg;
      "*color0" = dark;
      "*color1" = red;
      "*color2" = green;
      "*color3" = yellow;
      "*color4" = blue;
      "*color5" = purple;
      "*color6" = cyan;
      "*color7" = fg;
      "*color8" = dark;
      "*color9" = red;
      "*color10" = green;
      "*color11" = yellow;
      "*color12" = blue;
      "*color13" = purple;
      "*color14" = cyan;
      "*color15" = fg;

      # "URxvt.font" = "Fira Code:style=Regular:size=8";
      # "URxvt.boldFont" = "Fira Code:style=Bold:size=8";
      # "URxvt.italicFont" = "Fira Code:style=Italic:size=8";
      # "URxvt.boldItalicfont" = "Fira Code:style=Bold Italic:size=8";
      "URxvt.letterSpace" = "0";
      "URxvt.lineSpace" = "0";
      "URxvt.geometry" = "92x24";
      "URxvt.internalBorder" = "24";
      "URxvt.cursorBlink" = "true";
      "URxvt.cursorUnderline" = "false";
      "URxvt.saveline" = "2048";
      "URxvt.scrollBar" = "false";
      "URxvt.scrollBar_right" = "false";
      "URxvt.urgentOnBell" = "true";
      "URxvt.depth" = "24";
      "URxvt.iso14755" = "false";

      "URxvt.keysym.Shift-Up" = "command:\\033]720;1\\007";
      "URxvt.keysym.Shift-Down" = "command:\\033]721;1\\007";
      "URxvt.keysym.Control-Up" = "\\033[1;5A";
      "URxvt.keysym.Control-Down" = "\\033[1;5B";
      "URxvt.keysym.Control-Right" = "\\033[1;5C";
      "URxvt.keysym.Control-Left" = "\\033[1;5D";

      # "emacs.color0" = dark;
      # "emacs.color1" = red;
      # "emacs.color2" = green;
      # "emacs.color3" = yellow;
      # "emacs.color4" = gray;
      # "emacs.color5" = purple;
      # "emacs.color6" = cyan;
      # "emacs.color7" = gray;
      # "emacs.color8" = alt;
      # "emacs.color9" = green;
      # "emacs.color10" = green;
      # "emacs.color11" = yellow;
      # "emacs.color12" = green;
      # "emacs.color13" = purple;
      # "emacs.color14" = cyan;
      # "emacs.color15" = fg;

    };
    home.activation.xrdb = {
      after = ["linkGeneration"];
      before = [];
      data = "DISPLAY=:0 ${pkgs.xorg.xrdb}/bin/xrdb -merge ${config.users.users.alukard.home}/.Xresources";
    };
  };
}