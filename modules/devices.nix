{ pkgs, lib, config, ... }:
with lib;
with types; {
  options = {
    device = mkOption { type = strMatching "[A-z]*-[A-z]*"; };
    devices = mkOption { type = attrs; };
    deviceSpecific = mkOption { type = attrs; };
  };
  config = {
    deviceSpecific = let
      device = config.device;
      devInfo = config.devices.${config.device};
    in rec {
      isLaptop = (!isNull (builtins.match ".*Laptop" device));
      isVM = (!isNull (builtins.match ".*VM" device));
      smallScreen = (device == "Dell-Laptop");
      isHost = (device == "AMD-Workstation");
      isShared = devInfo.isShared;
      cpu = devInfo.cpu.vendor;
      video = devInfo.video;
      isSSD = devInfo.drive.type == "ssd";
      enableDocker = devInfo.enableDocker;
      hostName = if !isNull devInfo.hostName then
        devInfo.hostName
      else
        device;
    };

    devices = {
      AMD-Workstation = {
        cpu = {
          vendor = "amd";
          clock = 3800;
          cores = 6;
        };
        drive = {
          type = "ssd";
          size = 250;
        };
        video = "amd";
        ram = 16;
        isShared = false;
        enableDocker = true;
        hostName = "ataraxia-pc";
      };
      PackardBell-Laptop = {
        cpu = {
          vendor = "intel";
          clock = 2500;
          cores = 2;
        };
        drive = {
          type = "hdd";
          size = 500;
        };
        video = "nvidia";
        ram = 6;
        isShared = true;
        enableDocker = false;
        hostName = null;
      };
      Dell-Laptop = {
        cpu = {
          vendor = "intel";
          clock = 1600;
          cores = 4;
        };
        drive = {
          type = "ssd";
          size = 250;
        };
        video = "intel";
        ram = 8;
        isShared = true;
        enableDocker = true;
        hostName = "dell-ataraxia";
      };
      NixOS-VM = {
        cpu = {
          vendor = "amd";
          clock = 3600;
          cores = 2;
        };
        drive = {
          type = "ssd";
          size = 12;
        };
        video = "virtualbox";
        ram = 4;
        isShared = false;
        enableDocker = false;
        hostName = null;
      };
    };
  };
}
