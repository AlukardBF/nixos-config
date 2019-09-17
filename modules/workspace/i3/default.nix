{ pkgs, config, ... }:
let
  thm = config.themes.colors;
  apps = config.defaultApplications;
  customPackages = pkgs.callPackage ../../../packages { };
in {
  systemd.services.changeNice = {
    description = "Update niceness levels of important processes";
    serviceConfig.User = "root";
    wantedBy = [ "graphical.target" ];
    script = ''
      sleep 5
      ${pkgs.utillinux}/bin/renice -n -10 -p $(${pkgs.procps}/bin/pidof i3)
      ${pkgs.utillinux}/bin/renice -n -10 -p $(${pkgs.procps}/bin/pidof X)
    '';
  };
  environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";
  home-manager.users.alukard.xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      assigns = {
        "" = [ { class = "Chromium"; } { class = "Firefox"; } ];
        "" = [
          { class = "^Telegram"; }
          { class = "^VK"; }
          { class = "^trojita"; }
          { title = "weechat"; }
          { class = "nheko"; }
        ];
        "ﱘ" = [{ class = "cantata"; }];
      };
      bars = [ ];
      fonts = [ "RobotoMono 9" ];

      colors = rec {
        background = thm.bg;
        unfocused = {
          text = thm.alt;
          border = thm.dark;
          background = thm.bg;
          childBorder = thm.dark;
          indicator = thm.fg;
        };
        focusedInactive = unfocused;
        urgent = unfocused // {
          text = thm.fg;
          border = thm.orange;
          childBorder = thm.orange;
        };
        focused = unfocused // {
          childBorder = thm.blue;
          border = thm.blue;
          background = thm.dark;
          text = thm.fg;
        };
      };
      gaps = {
        inner = 6;
        smartGaps = true;
        smartBorders = "on";
      };
      focus.mouseWarping = true;
      focus.followMouse = false;
      modifier = "Mod4";
      window = {
        border = 1;
        titlebar = false;
        hideEdgeBorders = "smart";
        commands = [
          {
            command = "border pixel 2px";
            criteria = { window_role = "popup"; };
          }
          {
            command = "floating disable";
            criteria = { class = "pavucontrol-qt"; };
          }
        ];
      };
      # startup = map (a: { notification = false; } // a) [
      #   { command = apps.browser.cmd; }
      #   { command = "${pkgs.kdeconnect}/lib/libexec/kdeconnectd"; }
      #   {
      #     command =
      #       "${pkgs.polkit-kde-agent}/lib/libexec/polkit-kde-authentication-agent-1";
      #   }
      #   {
      #     command =
      #       "${pkgs.keepassxc}/bin/keepassxc /home/alukard/projects/nixos-config/misc/Passwords.kdbx";
      #   }
      #   { command = "balooctl start"; }
      #   { command = "${pkgs.trojita}/bin/trojita"; }
      #   {
      #     command = "${pkgs.hsetroot}/bin/hsetroot -solid '${thm.bg}'";
      #     always = true;
      #   }
      #   { command = "${pkgs.termNote}/bin/noted"; }
      #   { command = "${pkgs.nheko}/bin/nheko"; }
      # ];
      keybindings = let
        moveMouse = ''
          "sh -c 'eval `${pkgs.xdotool}/bin/xdotool \
                getactivewindow \
                getwindowgeometry --shell`; ${pkgs.xdotool}/bin/xdotool \
                mousemove \
                $((X+WIDTH/2)) $((Y+HEIGHT/2))'"'';
        in ({
          "${modifier}+q" = "kill";
          "${modifier}+w" = "exec ${apps.dmenu.cmd}";
          "${modifier}+Return" = "exec ${apps.term.cmd}";
          "${modifier}+e" = "exec ${apps.editor.cmd} -c -n";
          "${modifier}+y" = "exec ${apps.youtube-to-mpv.cmd}";
          "${modifier}+l" = "layout toggle";
          "${modifier}+Left" = "focus child; focus left; exec ${moveMouse}";
          "${modifier}+Right" = "focus child; focus right; exec ${moveMouse}";
          "${modifier}+Up" = "focus child; focus up; exec ${moveMouse}";
          "${modifier}+Down" = "focus child; focus down; exec ${moveMouse}";
          "${modifier}+Control+Left" =
            "focus parent; focus left; exec ${moveMouse}";
          "${modifier}+Control+Right" =
            "focus parent; focus right; exec ${moveMouse}";
          "${modifier}+Control+Up" =
            "focus parent; focus up; exec ${moveMouse}";
          "${modifier}+Control+Down" =
            "focus parent; focus down; exec ${moveMouse}";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Right" = "move right";
          "${modifier}+Shift+Left" = "move left";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+r" = "mode resize";
          "${modifier}+Shift+f" = "floating toggle";
          "${modifier}+d" = "exec ${apps.fm.cmd}";
          "${modifier}+Escape" = "exec ${apps.monitor.cmd}";
          "${modifier}+Print" = "exec ${pkgs.spectacle}/bin/spectacle -b";
          "${modifier}+Control+Print" = "exec ${pkgs.spectacle}/bin/spectacle";
          "--release ${modifier}+Shift+Print" =
            "exec ${pkgs.spectacle}/bin/spectacle -b -r";
          "--release ${modifier}+Control+Shift+Print" =
            "exec ${pkgs.spectacle}/bin/spectacle -r";
          "${modifier}+x" = "move workspace to output right";
          "${modifier}+c" = "workspace ";
          "${modifier}+Shift+c" = "move container to workspace ";
          "${modifier}+t" = "workspace ";
          "${modifier}+Shift+t" = "move container to workspace ";
          "${modifier}+m" = "workspace ﱘ";
          "${modifier}+Shift+m" = "move container to workspace ﱘ";
          "${modifier}+k" = "exec '${pkgs.xorg.xkill}/bin/xkill'";
          "${modifier}+F5" = "restart";
          "${modifier}+Shift+F5" = "exit";
          "${modifier}+Shift+h" = "layout splith";
          "${modifier}+Shift+v" = "layout splitv";
          "${modifier}+h" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+F1" = "move to scratchpad";
          "${modifier}+F2" = "scratchpad show";
          "${modifier}+i" =
            "exec sh -c 'xclip -selection clipboard -out | curl -F \"f:1=<-\" ix.io | xclip -selection clipboard -in'";
          # "${modifier}+z" = "exec ${pkgs.lambda-launcher}/bin/lambda-launcher";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
          "--release button2" = "kill";
          "--whole-window ${modifier}+button2" = "kill";
        } // builtins.listToAttrs (builtins.genList (x: {
          name = "${modifier}+${toString x}";
          value = "workspace ${toString x}";
        }) 10) // builtins.listToAttrs (builtins.genList (x: {
          name = "${modifier}+Shift+${toString x}";
          value = "move container to workspace ${toString x}";
        }) 10));
      keycodebindings = {
        "122" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
        "123" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
        "121" = "exec ${pkgs.pamixer}/bin/pamixer -t";
      };
      workspaceLayout = "tabbed";
    };
  };
}
