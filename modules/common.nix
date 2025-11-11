{ config, pkgs, ... }:
{
  # Base system
  time.timeZone = "Asia/Singapore";
  i18n.defaultLocale = "en_US.UTF-8";
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";

  # Networking + NetworkManager for Wi-Fi
  networking.networkmanager.enable = true;

  # Allow unfree + pull experimental pkgs via overlay
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Useful tools
  environment.systemPackages = with pkgs; [
    git 
    vim 
    curl 
    wget 
    htop
    sops 
    age 
    age-plugin-yubikey
    yubikey-manager 
    yubikey-personalization
    networkmanager
    firefox
  ];

  # YubiKey daemon
  services.pcscd.enable = true;

  #sops.age.keyFile = null;  # use YubiKey via age-plugin-yubikey
  sops.age.keyFile = "/root/.config/sops/age/keys.txt";

  sops.secrets.rudolfratusinski = {
    sopsFile = ../secrets/users.yaml;
    format = "yaml";
    # key = "rudolfratusinski";
    neededForUsers = true;
  };

  users.users.rudolfratusinski = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.rudolfratusinski.path;
  };

  programs.zsh.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
