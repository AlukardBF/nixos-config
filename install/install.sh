#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git
cd ..
CONFIG_FOLDER=$(pwd)
cd install

ENCRYPT_ROOT=false
FORMAT_BOOT_PARTITION=false

DEVICE_NAME=Dell-Laptop
MAX_JOBS=8
DEVICE=/dev/nvme0n1
BOOT_PARTITION=/dev/nvme0n1p1
SWAP_PARTITION=/dev/nvme0n1p3
ROOT_PARTITION=/dev/nvme0n1p2
ROOT_NAME=cryptnixos

gdisk $DEVICE

# Format boot partition
if [[ "$FORMAT_BOOT_PARTITION" == true ]]; then
  mkfs.vfat -n BOOT $BOOT_PARTITION
fi
# Create luks partition
if [[ "$ENCRYPT_ROOT" == true ]]; then
  cryptsetup --type luks2 --cipher aes-xts-plain64 --key-size 256 --hash sha512 luksFormat $ROOT_PARTITION
  cryptsetup luksOpen --type luks2 $ROOT_PARTITION $ROOT_NAME
  ROOT_NAME=/dev/mapper/$ROOT_NAME
  mkfs.f2fs -f -l root $ROOT_NAME
  mount $ROOT_NAME /mnt
else
  ROOT_NAME=$ROOT_PARTITION
  mkfs.f2fs -f -l root $ROOT_PARTITION
  mount $ROOT_PARTITION /mnt
fi
# Mount boot
mkdir /mnt/boot
mount $BOOT_PARTITION /mnt/boot
# Create swap
mkswap -L swap $SWAP_PARTITION
# Generate config (hardware)
nixos-generate-config --root /mnt/
cp /mnt/etc/nixos/hardware-configuration.nix $CONFIG_FOLDER/hardware-configuration/$DEVICE_NAME.nix
sed -i 's#<nixpkgs/nixos/modules/installer/scan/not-detected.nix>#"${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"#' $CONFIG_FOLDER/hardware-configuration/$DEVICE_NAME.nix
cp ./min-config.nix /mnt/etc/nixos/configuration.nix

nixos-install -I nixpkgs=https://github.com/NixOS/nixpkgs-channels/archive/840c782d507d60aaa49aa9e3f6d0b0e780912742.tar.gz --max-jobs $MAX_JOBS --no-root-passwd

mkdir -p /mnt/home/alukard/nixos-config
cp -aT $CONFIG_FOLDER /mnt/home/alukard/nixos-config
echo "Installation complete!"