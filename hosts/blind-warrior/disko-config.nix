/* fileSystems."/" = {
     device = "/dev/disk/by-uuid/0059b843-c9b4-401d-9459-ab47c4c45d83";
     fsType = "ext4";
   };

   fileSystems."/boot" = {
     device = "/dev/disk/by-uuid/2380-EBDB";
     fsType = "vfat";
     options = [ "fmask=0077" "dmask=0077" ];
   };

   swapDevices =
     [{ device = "/dev/disk/by-uuid/59597612-8929-44f0-9ea8-b3f7b5bd19a0"; }];
*/

{
  disko.devices = {
    disk = {
      nixos = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
