{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "parallels";

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  hardware.parallels.enable = true;

  services.qemuGuest.enable = false;
  services.spice-vdagentd.enable = false;
}
