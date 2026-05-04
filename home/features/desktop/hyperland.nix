{ config, lib, ... }:
with lib;
let cfg = config.features.desktop.hyprland;
in {
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = ",preferred,auto,1";

        env = [ 
          "XCURSOR_SIZE,32"
          "WLR_NO_HARDWARE_CURSORS,1"
          # "GTK_THEME,Dracula"
          "GTK_THEME,Adwaita:dark"
          "QT_STYLE_OVERRIDE,Adwaita-dark"
          "COLOR_SCHEME,prefer-dark"
          "GTK_APPLICATION_PREFER_DARK_THEME,1"
        ];

        exec-once = [
          "waybar"
          "swww init"  # Initialize swww daemon
          "wallpaper-rotate"  # Set random wallpaper at startup
          "wl-paste --type text --watch cliphist store"  # Start clipboard history daemon
          "wl-paste --type image --watch cliphist store"  # Store image clipboard items
          "gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'"  # Set GTK dark theme
          "gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'"  # Set color scheme preference
          # "waybar"
          # "hyprpaper"
          # "hypridle"
          # ''
          #   wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"''
        ];

        # xwayland = { force_zero_scaling = true; };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, T, exec, alacritty"
          "$mainMod, S, exec, wofi --show drun --allow-images"
          "$mainMod, E, exec, nautilus"
          "$mainMod, L, exec, hyprlock"
          "$mainMod, X, exec, wlogout"

          # -- Window Management --
          "$mainMod, Q, killactive"
          "$mainMod, M, exit"
          "$mainMod, F, fullscreen"
          # "$mainMod, V, togglefloating"
          "$mainMod, P, pseudo, # dwindle"
          "$mainMod SHIFT, P, togglesplit, # dwindle"

          # -- Move/Focus window --
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          "$mainMod SHIFT, left, movewindow, l"
          "$mainMod SHIFT, right, movewindow, r"
          "$mainMod SHIFT, up, movewindow, u"
          "$mainMod SHIFT, down, movewindow, d"

          # -- Clipboard Manager --
          "$mainMod, V, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

          # -- Workspace Navigation --
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          # layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 5;
            passes = 2;
          };
          # active_opacity = 0.9;
          # inactive_opacity = 0.5;
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            # "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # input = {
        #   kb_layout = "us,ru";
        #   kb_variant = "";
        #   kb_model = "";
        #   kb_rules = "";
        #   kb_options = "grp:win_space_toggle";
        #   follow_mouse = 1;
        #   touchpad = { natural_scroll = false; };
        #   sensitivity = 0;
        # };
        #
        # gestures = { workspace_swipe_touch = true; };
        #
        # dwindle = {
        #   pseudotile = true;
        #   preserve_split = true;
        # };
        #
        # master = { };
      };
    };
  };
}
