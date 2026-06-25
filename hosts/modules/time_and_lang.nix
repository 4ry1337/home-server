{ ...}:
let
  timezone = "Asia/Almaty";
  locale = "en_US.UTF-8";
  locale_extra = "ru_RU.UTF-8";
in {
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  i18n.extraLocales = [ "en_US.UTF-8/UTF-8" "ru_RU.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale_extra;
    LC_IDENTIFICATION = locale_extra;
    LC_MEASUREMENT = locale_extra;
    LC_MONETARY = locale_extra;
    LC_NAME = locale_extra;
    LC_NUMERIC = locale_extra;
    LC_PAPER = locale_extra;
    LC_TELEPHONE = locale_extra;
    LC_TIME = locale_extra;
  };
  services.xserver = {
    enable = true;
    exportConfiguration = true; # Make sure /etc/X11/xkb is populated so localectl works correctly
    xkb = {
      layout = "us,ru";
      variant = "";
      options = "caps:swapescape grp:win_space_toggle";
    };
  };
}
