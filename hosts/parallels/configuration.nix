{ config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "parallels";

  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  hardware.parallels.enable = true;

  services.qemuGuest.enable = false;
  services.spice-vdagentd.enable = false;
}
