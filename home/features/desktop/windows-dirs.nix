{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.desktop.windows-dirs;
  windowsHome = "/mnt/windows/Users/${cfg.username}";
in
{
  options.features.desktop.windows-dirs = {
    enable = mkEnableOption "Symlink Windows user directories into Linux XDG directories";

    username = mkOption {
      type = types.str;
      default = "thego";
      description = "Windows username whose user directories are shared with Linux.";
    };
  };

  config = mkIf cfg.enable {
    home.file = {
      "Desktop".source = config.lib.file.mkOutOfStoreSymlink "${windowsHome}/Desktop";
      "Documents".source = config.lib.file.mkOutOfStoreSymlink "${windowsHome}/Documents";
      "Downloads".source = config.lib.file.mkOutOfStoreSymlink "${windowsHome}/Downloads";
      "Music".source = config.lib.file.mkOutOfStoreSymlink "${windowsHome}/Music";
      "Pictures".source = config.lib.file.mkOutOfStoreSymlink "${windowsHome}/Pictures";
      "Videos".source = config.lib.file.mkOutOfStoreSymlink "${windowsHome}/Videos";
    };
  };
}
