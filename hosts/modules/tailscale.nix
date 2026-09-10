{ config, ... }:
{
  age.secrets.tailscale-authkey.file = ../../secrets/tailscale-authkey.age;

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-authkey.path;
    openFirewall = true;
  };

  # tailnet is trusted — also lets the host's services (AdGuard, DNS, …) be
  # reached over tailscale0 without per-port firewall rules
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
