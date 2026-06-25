{
  config,
  pkgs,
  inputs,
  ...
}:
{
  users.users.rakhat = {
    initialHashedPassword = "$y$j9T$IDkYUSjCVv0d7/tURzT/z0$cUeIhq8Z39jrnsMsfwmtV1SZwK3Yl1qZH/fVWOUwOg2";
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
    packages = [ inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
  home-manager.users.rakhat = import ../../../home/rakhat/${config.networking.hostName}.nix;

  console = {
    useXkbConfig = true;
    font = "spleen-16x32";
    packages = [ pkgs.spleen ];
    colors = [
      "1e1e2e" # black       (base)
      "f38ba8" # red
      "a6e3a1" # green
      "f9e2af" # yellow
      "89b4fa" # blue
      "cba6f7" # magenta     (mauve)
      "94e2d5" # cyan        (teal)
      "bac2de" # white       (subtext1)
      "585b70" # bright black (surface2)
      "f38ba8" # bright red
      "a6e3a1" # bright green
      "f9e2af" # bright yellow
      "89b4fa" # bright blue
      "cba6f7" # bright magenta
      "94e2d5" # bright cyan
      "cdd6f4" # bright white (text)
    ];
  };
}
