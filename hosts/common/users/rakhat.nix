{ config, pkgs, inputs, ... }: {
  users.users.rakhat = {
    initialHashedPassword =
      "$y$j9T$FpPS/JnWHSCjY3pc6/VeU/$Z2GFHBeWdtF6/o6p7vb93tKcYHx/V5brp.a2N3dcjhA";
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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVduyDowbgTbA7h8uKunUTZZhDsqPGBgkkAL8uOiMx6tcxxLqSDJ+ZjLky/zAh+LDyW8KfrBEASOrH9UfiGuaeq/9sMqZFHuQY6hjE3r5uJlO8a3VyIoOh9eoZswZgzELk1GBU3SF3yq028SPD5xrhV4xp8Hq/lFLooNTUMi3hzSDKEB05SWaXu89D3RW9bO1A++ByBp93l6JXTpOItZX3+vraEjgRiLUXWx6CGlAIgCWhmSv+i+C5k4wkWU65PLSxKzVXJEyHQ62TWf1tzyInMuMz7r3TX+YCMYeDOSR946tpKcx4rJJ8vwzptS3zIhCmTFy5xvHrY5bD75CeRTj4K7ev3qwLrAffeWlCnB+VrI50z/QGnHG0PHU4N2wndUkwqhCv3/Ev2Wxwe46AQ1Rkro9cFkJ0uSiKxJxKFyo82Xq9iWs4z0EXic6WndAEOYXhW9e8m1jCLdrQRKg+KhC9B14qJFUD6ZNZUNcFJ7BFCqaQE9hsdmAXTPSElnoFf6M= rakhat@blind-warrior"
    ];
    packages = [ inputs.home-manager.packages.${pkgs.system}.default ];
  };
  home-manager.users.rakhat =
    import ../../../home/rakhat/${config.networking.hostName}.nix;
}
