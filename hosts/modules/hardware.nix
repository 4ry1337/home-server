{ lib, ... }:
{
  hardware.graphics.enable = true;

  hardware.nvidia.prime = {
    offload.enable = lib.mkForce false;
    offload.enableOffloadCmd = lib.mkForce false;
    sync.enable = lib.mkForce true;
  };
}
