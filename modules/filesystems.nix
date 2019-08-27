{ pkgs, lib, config, ... }: {
  fileSystems = {
    "/" = {
      options = [ "subvol=nixos" "discard" "ssd" "noatime" "compress=zstd" ];
    };
    "/shared" = {
      fsType = "vboxsf";
      device = "shared";
      options = [ "rw" "nodev" "relatime" "iocharset=utf8" "uid=1000" "gid=100" "dmode=0770" "fmode=0770" "nofail" ];
    };
  };

  # mount swap
  swapDevices = [
    { label = "swap"; }
  ];
}