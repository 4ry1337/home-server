# obs-spotify-widget

Package lives in `pkgs/obs-spotify-widget/default.nix`, sourced from [4ry1337/obs_things](https://github.com/4ry1337/obs_things).

## Updating

When bumping `rev` to a new commit, update both `hash` (src) and `cargoHash` using `nix-update`:

```bash
# 1. update rev in pkgs/obs-spotify-widget/default.nix manually
# 2. then run:
nix run nixpkgs#nix-update -- -F obs-spotify-widget --version=fixed
```

`--version=fixed` keeps the pinned rev and only refreshes the hashes.

## Manual fallback

If `nix-update` fails, use the fake-hash trick:

1. Set `hash = lib.fakeHash;` → build, copy the `got:` hash → paste in
2. Set `cargoHash = lib.fakeHash;` → build, copy the `got:` hash → paste in
