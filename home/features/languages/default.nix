{ pkgs, ... }: {
  home.packages = with pkgs; [
    devenv
    gcc
    vulkan-tools # Graphics debugging tools
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
