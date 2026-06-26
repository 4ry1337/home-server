## Update dotfiles

```
nix flake update
```

## Rebuild commands

Activate and save to bootloader (permanent):
```
sudo nixos-rebuild switch
```

Activate now, revert on reboot (safe testing):
```
sudo nixos-rebuild test
```

Save to bootloader, apply on next reboot:
```
sudo nixos-rebuild boot
```

## Clean up NixOS

Remove old generations and collect garbage:
```
sudo nix-collect-garbage -d
```

Update bootloader to remove old entries:
```
sudo nixos-rebuild switch
```
