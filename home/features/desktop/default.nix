{ pkgs, ... }: {
  imports = [ ./wayland.nix ./hyperland.nix ./fonts.nix ];

  home.packages = with pkgs; [
    stable.libnotify            # Desktop notifications
    stable.pwvucontrol          # PipeWire volume control
    stable.btop                 # System monitor
    stable.lm_sensors           # Hardware sensors
    stable.nvtopPackages.nvidia # GPU monitoring for btop

    # Media and Screenshot Tools (Unstable)
    grim               # Wayland screenshot tool
    slurp              # Screen area selection
    wl-clipboard       # Wayland clipboard
    cliphist           # Clipboard history manager
    loupe              # Image viewer
  ];
}
