## gdu

TUI disk usage starting at current directory:
```
gdu
```

Scan from a specific path:
```
gdu /home
gdu /
```

Plain text output, no TUI:
```
gdu -n /home
```

Show only directories:
```
gdu -d /home
```

Skip virtual filesystems:
```
gdu --ignore-dirs /proc,/sys,/dev /
```

Export results to JSON:
```
gdu -o output.json /home
```

TUI keybindings: `arrows` navigate, `d` delete, `r` rescan, `q` quit

---

## duf

Show all mounted filesystems:
```
duf
```

Show usage for a specific path:
```
duf /home
```

Only local disks:
```
duf --only local
```

Only network mounts:
```
duf --only network
```

Hide tmpfs, devtmpfs, and other special filesystems:
```
duf --hide special
```

Custom columns:
```
duf --output mountpoint,size,used,avail,usage
```

Sort by size:
```
duf --sort size
```

JSON output:
```
duf --json
```

---

## dust

Usage of current directory:
```
dust
```

Specific directory:
```
dust /home
```

Limit depth:
```
dust -d 2
```

Show top 20 entries:
```
dust -n 20
```

Files only, no directories:
```
dust -f
```

Exclude a pattern:
```
dust -X .git
```

Full paths:
```
dust -p
```

Apparent size instead of disk usage:
```
dust -s
```

Reverse sort (smallest first):
```
dust -r
```

No bar chart, plain output:
```
dust -b
```

---

## ouch

Compress a file or directory:
```
ouch compress file.txt archive.tar.gz
ouch compress dir/ archive.zip
ouch compress dir/ archive.tar.zst
ouch compress file.txt archive.7z
```

Compress multiple files:
```
ouch compress *.log logs.tar.gz
```

Decompress an archive:
```
ouch decompress archive.tar.gz
```

Decompress to a specific directory:
```
ouch decompress archive.zip -d /tmp/out/
```

List contents without extracting:
```
ouch list archive.tar.gz
ouch list archive.zip
ouch list archive.7z
```

Supported formats: `.tar.gz` `.tar.bz2` `.tar.xz` `.tar.zst` `.zip` `.7z` `.gz` `.bz2` `.xz` `.zst` `.lz4`

---

## smartmontools

List all detected drives:
```
sudo smartctl --scan
```

Full health report:
```
sudo smartctl -a /dev/nvme0
sudo smartctl -a /dev/sda
```

Health check only (PASSED / FAILED):
```
sudo smartctl -H /dev/nvme0
```

Drive info (model, serial, firmware):
```
sudo smartctl -i /dev/nvme0
```

Error log:
```
sudo smartctl -l error /dev/nvme0
```

Self-test history:
```
sudo smartctl -l selftest /dev/nvme0
```

Run a short self-test (~2 minutes):
```
sudo smartctl -t short /dev/nvme0
```

Run a long self-test (can take hours):
```
sudo smartctl -t long /dev/nvme0
```

Abort a running self-test:
```
sudo smartctl -X /dev/nvme0
```

---

## nvme-cli

List all NVMe devices:
```
sudo nvme list
```

Controller information:
```
sudo nvme id-ctrl /dev/nvme0
```

Namespace information:
```
sudo nvme id-ns /dev/nvme0n1
```

SMART health log (temperature, wear, errors):
```
sudo nvme smart-log /dev/nvme0
```

Error log:
```
sudo nvme error-log /dev/nvme0
```

Firmware log:
```
sudo nvme fw-log /dev/nvme0
```

Self-test (short):
```
sudo nvme device-self-test /dev/nvme0 -s 1
```

Self-test (extended):
```
sudo nvme device-self-test /dev/nvme0 -s 2
```

Check self-test progress/result:
```
sudo nvme self-test-log /dev/nvme0
```

Sanitize (secure erase — destructive):
```
sudo nvme sanitize /dev/nvme0 -a 2
```

---

## rsync

Sync two local directories:
```
rsync -av src/ dst/
```

Preview without making changes:
```
rsync -av --dry-run src/ dst/
```

Sync and delete files removed from source:
```
rsync -av --delete src/ dst/
```

Sync to a remote host (compressed):
```
rsync -avz src/ user@host:dst/
```

With progress bar:
```
rsync -avzP src/ user@host:dst/
```

Sync from remote to local:
```
rsync -avz user@host:src/ dst/
```

Custom SSH port:
```
rsync -e "ssh -p 2222" src/ user@host:dst/
```

Exclude a pattern:
```
rsync -av --exclude='.git' src/ dst/
```

Exclude from a file:
```
rsync -av --exclude-from=.gitignore src/ dst/
```

Verify by checksum instead of timestamp:
```
rsync -av --checksum src/ dst/
```

Limit bandwidth (10 MB/s):
```
rsync -av --bwlimit=10000 src/ dst/
```

Keep backups of overwritten files:
```
rsync -av --backup --backup-dir=/tmp/backup src/ dst/
```

Show progress for a single large file:
```
rsync --progress src/bigfile dst/
```
