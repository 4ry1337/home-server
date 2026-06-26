{ ... }:
{
  services.upower.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
    KillUserProcesses = false;
  };
}
