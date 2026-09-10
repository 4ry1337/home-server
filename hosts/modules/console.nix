{ ... }:
{
  # Userspace VT console (replaces the in-kernel VT): TrueType fonts, full
  # Unicode, GPU rendering. Replaces getty@ on the text consoles.
  services.kmscon = {
    enable = true;
    config.hwaccel = true; # requires hardware.graphics.enable (set by Hyprland)
  };
}
