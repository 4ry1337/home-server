{...}:
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      # Disable password login — only SSH keys are accepted.
      # This prevents brute-force attacks. Make sure your key is in
      # users.users.rakhat.openssh.authorizedKeys.keys before switching.
      PasswordAuthentication = false;
    };
  };
}
