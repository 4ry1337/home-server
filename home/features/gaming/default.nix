{ pkgs, ... }: {
  imports = [ ];

  home.packages = with pkgs; [
    steam              # Gaming platform
    protonup-qt        # Proton version manager
    gamemode           # Game performance optimization
    gamescope          # Gaming compositor
    vulkan-tools       # Graphics debugging tools
    prismlauncher      # Minecraft launcher (maintained alternative)
    # wowup-cf           # World of Warcraft addon manager (CurseForge)
    r2modman           # Thunderstore mod manager (Risk of Rain 2, Lethal Company, etc.)
  ];
}
