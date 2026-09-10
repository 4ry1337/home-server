{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.features.apps.media;

  imageMimes = [
    "image/jpeg"
    "image/png"
    "image/gif"
    "image/webp"
    "image/avif"
    "image/tiff"
    "image/bmp"
    "image/jxl"
    "image/heif"
    "image/svg+xml"
    # RAW (not in swayimg.desktop's own MimeType list)
    "image/x-canon-cr2"
    "image/x-canon-cr3"
    "image/x-nikon-nef"
    "image/x-sony-arw"
    "image/x-adobe-dng"
    "image/x-fujifilm-raf"
    "image/x-panasonic-rw2"
    "image/x-olympus-orf"
  ];
in {
  options.features.apps.media.enable = mkEnableOption "Enable media applications";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vlc
      calibre
      onlyoffice-desktopeditors
    ];

    programs.zathura.enable = true;

    programs.swayimg = {
      enable = true;
      initLua = ''
        -- open one image -> also load its folder, so PgUp/PgDown navigate the dir
        swayimg.imagelist.adjacent = true
      '';
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = genAttrs imageMimes (_: "swayimg.desktop");
    };
  };
}
