{ config, lib, pkgs, ... }:
let
  device = config.devices.${config.device};
in {

  services.acpid.enable = true;

  # services.btrfs.autoScrub = {
  #   enable = true;
  #   interval = "weekly";
  # };

  services.redshift = {
    enable = true;
    temperature.day = 5500;
    temperature.night = 3000;
  };

  services.earlyoom = {
    enable = device.ram < 12;
    freeMemThreshold = 5;
    freeSwapThreshold = 100;
  };

  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
  };
  programs.dconf.enable = true;
  programs.gnupg.agent.enable = true;

  services.accounts-daemon.enable = true;

  services.avahi = {
    enable = true;
    # ipv6 = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

  systemd.services.systemd-udev-settle.enable = false;

  services.upower.enable = true;

  services.gnome3.gnome-keyring.enable = true;

  virtualisation.docker.enable = device.enableVirtualisation;

  # virtualisation.virtualbox.host = {
  #   enable = device.enableVirtualisation;
  #   # enableHardening = false;
  #   enableExtensionPack = false;
  # };

  # Install cdemu for some gaming purposes
  # programs.cdemu = {
  #   enable = true;
  #   image-analyzer = false;
  #   gui = false;
  #   group = "cdrom";
  # };

}
