{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.rakhat = {
    initialHashedPassword = "$y$j9T$FpPS/JnWHSCjY3pc6/VeU/$Z2GFHBeWdtF6/o6p7vb93tKcYHx/V5brp.a2N3dcjhA";
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZlNyr14Ak7PV0y6GOVBaWH5IcWing9PvjZVEqtJDnt91lj9UZehOeIKpE/PMv2lmhf6LFGoUQtOD7RGBhFSfZEdsGtEso2p4f7QKqwNS6C1wbDaoCUCYXVyhi2EwRA5anWLaCHfcMzkp/zk/DCDIJY2OQhvuE37HL2VxYrtEXQw3XiNXB1UMGETQsz6Ess/oGsdO0qXOGt66c6hdwTAWr1mFqr+QMuQ3cTQibOO5AciwKLVAPg2nJEzRImQhNu/q2hOT4/Bpp00R+dqnik/hRHecsETxj9vy3i9ktibwYg8f3hXXCPIH8RUxgfia7AzvRHME21/MO1MywGLEM+AftZzBBlT6wPBOPswasUje1HvyVdC7KAkZCm34gQ0FG8JeNuRghyd2+5Ts8NNea2qQz7wE3oB+NBv3VTPqUo8+285Zf5ESx3owhatQtEBMZnlJflGrEThx9jKVR7fSj9F2459HyttydpevvwQDZn1OsS6xCKp+lNuHCiRY6KanjTUE= rakhat@blind-warrior"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.rakhat =
    import ../../../home/rakhat/${config.networking.hostName}.nix;
}
