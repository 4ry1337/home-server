{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.apps.blender;
in
{
  options.features.apps.blender.enable = mkEnableOption "Enable blender application";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      blender

      # GPU rendering (Cycles): swap the line above for
      #   (blender.override { cudaSupport = true; })
      # This variant is NOT on cache.nixos.org. To avoid compiling it locally,
      # add the cuda-maintainers substituter in hosts/common/default.nix
      # `nix.settings`:
      #   substituters       = [ "https://cuda-maintainers.cachix.org" ];
      #   trusted-public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
      # Do NOT set nixpkgs.config.cudaSupport globally — override blender only.
    ];
  };
}
