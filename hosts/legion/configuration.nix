{ config, pkgs, nixos-hardware, ... }:
{
  imports = [
    nixos-hardware.nixosModules.lenovo-legion-16achg6-hybrid
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "legion";

  # --- Secrets managed by sops-nix ---
  sops.secrets."powerpuff" = {
    sopsFile = ../../secrets/wifi.yaml;
    format = "yaml";
  };

  networking.networkmanager.ensureProfiles.profiles."powerpuff-wifi" = {
    connection = {
      type = "802-11-wireless";
      id = "powerpuff-wifi";
    };
    "802-11-wireless" = {
      ssid = "powerpuff";
      mode = "infrastructure";
    };
    "802-11-wireless-security" = {
      key-mgmt = "wpa-psk";
      psk = builtins.readFile config.sops.secrets."powerpuff".path;
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = {
      method = "auto";
    };
  };
}
