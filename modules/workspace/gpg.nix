{
  home-manager.users.alukard = {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentryFlavor = "gnome3";
      sshKeys = [ "E6A6377C3D0827C36428A290199FDB3B91414AFE" ];
    };
  };
}