{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage {
  pname = "obs-spotify-widget";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "4ry1337";
    repo = "obs_things";
    rev = "9aa39b970f25b4edc18a94860de6eae1395285f7";
    hash = "sha256-hWoU2cO6XjDahIVGXUjF1PBI7yVQcAulw9IJ52ckAw4=";
  };

  sourceRoot = "source/spotify_widget";

  cargoHash = "sha256-ox93yn0hLJ6QVzYH1QoF9EScFQYSTll1jle9hRB8hcY=";

  meta = with lib; {
    description = "OBS Spotify widget serving current track via MPRIS D-Bus";
    license = licenses.mit;
    maintainers = [ ];
  };
}
