# devenv

```bash
devenv init       # creates devenv.nix, .envrc, devenv.lock, .gitignore
direnv allow      # authorize this directory to run .envrc (once per project)
```

After `direnv allow`, the environment activates automatically on every `cd`.


## Common commands

```bash
direnv allow      # trust and activate .envrc in current directory
direnv deny       # deactivate and untrust current directory
direnv reload     # force reload after editing .envrc
direnv status     # show current status and .envrc path
```

## .envrc devenv generates

```bash
source_url "https://raw.githubusercontent.com/cachix/devenv/..." "<hash>"

use devenv
```

Do not edit this manually — `devenv init` manages it.

## Tips

- Add `.envrc` to `.gitignore` if it contains secrets, commit it if it only has `use devenv`
- `nix-direnv` caches the nix evaluation so re-entering the shell is instant after the first load
- If the shell feels slow on first entry, it's building the devenv — subsequent entries are cached
