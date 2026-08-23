{
  lib,
  hyprland,
  hyprlandPlugins,
  fetchFromGitHub,
}:

hyprlandPlugins.mkHyprlandPlugin {
  pluginName = "hyprexpo";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "sandwichfarm";
    repo = "hyprexpo";
    rev = "master";
    hash = "sha256-KGZFBldDdAgUuNRJYxhdIIQnnsTb+PMCScSnB8IGBH4=";
  };

  inherit (hyprland) nativeBuildInputs;

  meta = {
    homepage = "https://github.com/sandwichfarm/hyprexpo";
    description = "An enhanced Hyprland workspaces overview plugin";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
