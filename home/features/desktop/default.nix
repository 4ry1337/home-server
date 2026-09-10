{ pkgs, ... }: {
  imports = [
    ./hyprland
    ./windows-dirs.nix
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-application-prefer-dark-theme = true;
  };

  # FONTS
  home.packages = with pkgs; [
    openmoji-color
    nerd-fonts.iosevka
    nerd-fonts.iosevka-term
  ];
}
