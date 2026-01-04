{ config, pkgs, inputs, ... }: {
  users.users.rakhat = {
    initialHashedPassword =
      "$y$j9T$IDkYUSjCVv0d7/tURzT/z0$cUeIhq8Z39jrnsMsfwmtV1SZwK3Yl1qZH/fVWOUwOg2";
    isNormalUser = true;
    description = "rakhat";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBrSN9GF5+d66izZY24UaUcyj3V36Mt+H+ik/PUdm5rc yskak.rakhat@gmail.com"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };
  home-manager.users.rakhat =
    import ../../../home/rakhat/${config.networking.hostName}.nix;
}
