{ config, lib, pkgs, ... }: {
  # virtualisation.docker.enable = enableVirtualisation;
  # environment.systemPackages = lib.mkIf (enableVirtualisation) [ pkgs.docker-compose ];

  virtualisation.libvirtd = {
    enable = config.deviceSpecific.enableVirtualisation;
    qemuOvmf = true;
    qemuRunAsRoot = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemuPackage = pkgs.qemu;
  };

  virtualisation.spiceUSBRedirection.enable = config.deviceSpecific.enableVirtualisation;

  # virtualisation.anbox.enable = isGaming; # broken

  # virtualisation.virtualbox.host = {
  #   enable = false;
  #   # enableHardening = false;
  #   enableExtensionPack = false;
  # };
}