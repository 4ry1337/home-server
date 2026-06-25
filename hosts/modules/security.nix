{pkgs, ...}:
{
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    apparmor = {
      enable = false;
      killUnconfinedConfinables = true;
      packages = [ pkgs.apparmor-profiles ];
    };

    # Prevent replacing the running kernel without a reboot
    protectKernelImage = true;
    # Uncomment when using security.acme to auto-issue Let's Encrypt TLS certs
    # acme.acceptTerms = true;
  };
}
