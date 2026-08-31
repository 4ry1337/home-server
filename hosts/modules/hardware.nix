{ lib, ... }:
{
  hardware.graphics.enable = true;

  hardware.nvidia.prime = {
    offload.enable = lib.mkForce false;
    offload.enableOffloadCmd = lib.mkForce false;
    sync.enable = lib.mkForce true;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
