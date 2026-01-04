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
    # openssh.authorizedKeys.keys = [
    #   ""
    # ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };
  home-manager.users.rakhat =
    import ../../../home/rakhat/${config.networking.hostName}.nix;
}
