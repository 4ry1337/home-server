# Rust Dev Environment

## rust-toolchain.toml

Pin the toolchain for all contributors (rustup and devenv both respect this).

```toml
[toolchain]
channel = "nightly"
components = ["rustc", "cargo", "clippy", "rustfmt", "rust-analyzer"]
targets = ["x86_64-unknown-linux-gnu"]
```

Use a dated channel for full reproducibility:

```toml
[toolchain]
channel = "nightly-2025-01-15"
components = ["rustc", "cargo", "clippy", "rustfmt", "rust-analyzer"]
```

## devenv.nix

Point devenv at `rust-toolchain.toml` — it uses it directly via `toolchainFile`.
Cannot combine `toolchainFile` with `channel` or `version`.

```nix
{ pkgs, ... }:
{
  languages.rust = {
    enable = true;
    toolchainFile = ./rust-toolchain.toml;
    mold.enable = true;  # faster linker, optional
  };

  packages = [
    pkgs.cargo-audit
    pkgs.sqlx-cli
  ];
}
```

If you don't use a toolchain file, configure inline instead:

```nix
languages.rust = {
  enable = true;
  channel = "nightly";
  components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];
};
```

## Project layout

```
project/
├── rust-toolchain.toml   # toolchain for all users (rustup + devenv)
├── devenv.nix            # extra tools for Nix users
├── devenv.lock
├── .envrc                # direnv integration
├── Dockerfile
├── compose.yaml
└── src/
```

## Common commands

```bash
cargo fmt              # format (uses nightly rustfmt from toolchain)
cargo clippy           # lint
cargo audit            # check for vulnerabilities
sqlx migrate run       # run database migrations
```
