{ ... }:
{
  time.timeZone = "Asia/Almaty";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "kk_KZ.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "kk_KZ.UTF-8";
  };
  # WARN: enabling xserver also starts GDM by default — only enable when a desktop is configured
  /*
    services.xserver = {
      enable = true;
      exportConfiguration = true;
      xkb = {
        layout = "us,ru";
        variant = "";
        options = "caps:swapescape grp:win_space_toggle";
      };
    };
  */
}
