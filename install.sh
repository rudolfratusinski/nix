#!/usr/bin/env bash
set -euo pipefail
HOST="${1:-}"
if [ -z "$HOST" ]; then
  echo "Usage: $0 <HOSTNAME>"
  exit 1
fi

echo ">>> Partitioning with disko..."
nix --extra-experimental-features "nix-command flakes" \
  run github:nix-community/disko -- --mode disko ./hosts/$HOST/disko.nix

echo ">>> Installing NixOS from flake for $HOST..."
nixos-install --flake .#$HOST --no-root-passwd

echo ">>> Done. Reboot with your YubiKey inserted so sops-nix can decrypt Wi-Fi + secrets."
