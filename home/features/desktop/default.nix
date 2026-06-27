{ ... }: {
  imports = [
    ./fonts.nix
    ./hyprland
  ];

  gtk = {
    enable = true;
    gtk3.extraConfig."gtk-application-prefer-dark-theme" = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-application-prefer-dark-theme = true;
  };
}
