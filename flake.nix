{
  description = "Rudolf’s NixOS 25.05";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url         = "github:nix-community/disko";
    sops-nix.url      = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, disko, sops-nix, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    overlay-unstable = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

    # Discover all host directories
    hostDirs = builtins.readDir ./hosts;
    hostNames = lib.attrNames (lib.filterAttrs (name: type: type == "directory") hostDirs);

    # Build configuration for a single host
    mkHost = hostName: lib.nixosSystem {
      inherit system;
      modules = [
        ./modules/common.nix
        ./hosts/${hostName}/configuration.nix
        disko.nixosModules.disko
        sops-nix.nixosModules.sops
        { nixpkgs.overlays = [ overlay-unstable ]; }
      ];
    };
  in {
    nixosConfigurations = lib.genAttrs hostNames mkHost;
  };
}
