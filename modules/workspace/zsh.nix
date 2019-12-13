{ pkgs, config, ... }: {

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.SHELL = "zsh";
  home-manager.users.alukard.programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" "dirhistory" ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
         owner = "chisui";
         repo = "zsh-nix-shell";
         rev = "b2609ca787803f523a18bb9f53277d0121e30389";
         sha256 = "01w59zzdj12p4ag9yla9ycxx58pg3rah2hnnf3sw4yk95w3hlzi6";
       };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "2be37f376c13187c445ae9534550a8a5810d4361";
          sha256 = "0yhwn6av4q6hz9s34h4m3vdk64ly6s28xfd8ijgdbzic8qawj5p1";
        };
      }
    ];
    shellAliases = {
      "clr" = "clear";
      "weather" = "curl wttr.in/Volzhskiy";
      "l" = "ls -lah --group-directories-first";
      "rede" = "systemctl --user start redshift.service &";
      "redd" = "systemctl --user stop redshift.service &";
      "bare" = "systemctl --user start barrier-client.service &";
      "bard" = "systemctl --user stop barrier-client.service &";
      "wgup" = "_ systemctl start wg-quick-wg0.service";
      "wgdown" = "_ systemctl stop wg-quick-wg0.service";
    };
    initExtra = ''
      nixify() {
        if [ ! -e ./.envrc ]; then
          wget -O ./.envrc https://raw.githubusercontent.com/kalbasit/nur-packages/master/pkgs/nixify/envrc
          sed -i '$s/use_nix.\+/use_nix/' ./.envrc
          direnv allow
        fi
        if [ ! -e shell.nix ]; then
          cat > shell.nix <<'EOF'
      { pkgs ? import <nixpkgs> {} }:
      pkgs.mkShell {
        # Hack to SSL Cert error
        GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt;
        SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt;
        buildInputs = [];
      }
      EOF
        fi
      }
    '';
  };
}
