## mtr

Live traceroute with per-hop latency and packet loss:
```
mtr google.com
```

Run 10 cycles, print report, exit:
```
mtr --report google.com
```

More cycles for better statistics:
```
mtr --report --report-cycles 100 google.com
```

Skip hostname resolution (faster):
```
mtr --no-dns google.com
```

TCP mode on port 443 (bypasses ICMP blocks):
```
mtr --tcp --port 443 google.com
```

UDP mode:
```
mtr --udp google.com
```

Force IPv4 or IPv6:
```
mtr -4 google.com
mtr -6 google.com
```

---

## tcpdump

Capture on a specific interface:
```
tcpdump -i eth0
```

Capture on all interfaces:
```
tcpdump -i any
```

No DNS resolution, no port name translation:
```
tcpdump -i any -nn
```

Filter by port:
```
tcpdump -i any port 53
```

Filter by host:
```
tcpdump -i any host 1.1.1.1
```

Filter by source or destination:
```
tcpdump -i any 'src 192.168.0.1'
tcpdump -i any 'dst port 443'
```

Exclude SSH noise:
```
tcpdump -i any 'not port 22'
```

Only ICMP:
```
tcpdump -i any icmp
```

Capture only HTTP/HTTPS:
```
tcpdump -i any 'tcp port 80 or tcp port 443'
```

Capture Unbound resolver traffic directly:
```
tcpdump -i any udp port 5335
```

Capture AdGuard DNS:
```
tcpdump -i any port 53
```

Stop after 100 packets:
```
tcpdump -i any -c 100
```

Write capture to file:
```
tcpdump -i any -w capture.pcap
```

Read capture from file:
```
tcpdump -r capture.pcap
```

Verbose output:
```
tcpdump -i any -v
```

---

## nmap

Basic scan of a host:
```
nmap 192.168.0.1
```

Ping sweep — discover live hosts, no port scan:
```
nmap -sn 192.168.0.0/24
```

Specific ports:
```
nmap -p 22,80,443 192.168.0.1
```

Port range:
```
nmap -p 1-1000 192.168.0.1
```

All 65535 ports:
```
nmap -p- 192.168.0.1
```

Service version detection:
```
nmap -sV 192.168.0.1
```

OS detection:
```
nmap -O 192.168.0.1
```

Aggressive scan (OS + version + scripts + traceroute):
```
nmap -A 192.168.0.1
```

SYN scan (stealth, requires root):
```
sudo nmap -sS 192.168.0.1
```

UDP scan:
```
sudo nmap -sU 192.168.0.1
```

Only show open ports across a subnet:
```
nmap --open 192.168.0.0/24
```

Faster timing:
```
nmap -T4 192.168.0.1
```

Audit your own firewall:
```
nmap localhost
```

Save output to file:
```
nmap -oN output.txt 192.168.0.1
nmap -oG output.gnmap 192.168.0.1
```

---

## dnsutils

Basic A record lookup:
```
dig google.com
```

Specific record types:
```
dig google.com MX
dig google.com NS
dig google.com AAAA
dig google.com TXT
dig google.com SOA
```

Query a specific resolver:
```
dig @1.1.1.1 google.com
```

Query your local AdGuard:
```
dig @127.0.0.1 google.com
```

Query Unbound directly, bypassing AdGuard:
```
dig @127.0.0.1 -p 5335 google.com
```

Just the IP, no extra output:
```
dig +short google.com
```

Full resolution chain (trace from root):
```
dig +trace google.com
```

Reverse DNS lookup:
```
dig -x 8.8.8.8
```

Clean answer-only output:
```
dig +nocmd +noall +answer google.com
```

Simple lookups with host:
```
host google.com
host 8.8.8.8
```

Interactive resolver with nslookup:
```
nslookup google.com
nslookup google.com 127.0.0.1
```

---

## dog

Basic lookup:
```
dog google.com
```

Specific record types:
```
dog google.com MX
dog google.com AAAA
dog google.com TXT
dog google.com NS
```

Query a specific resolver:
```
dog @1.1.1.1 google.com
```

Query your local stack:
```
dog @127.0.0.1 google.com
```

Force transport:
```
dog --udp google.com
dog --tcp google.com
dog --tls google.com
dog --https google.com
```

JSON output:
```
dog -J google.com
```

---

## iperf3

Start a server on the target machine:
```
iperf3 -s
```

Start server on a specific port:
```
iperf3 -s -p 5201
```

Run a TCP test from client:
```
iperf3 -c 192.168.0.1
```

UDP test:
```
iperf3 -c 192.168.0.1 -u
```

Run for 30 seconds:
```
iperf3 -c 192.168.0.1 -t 30
```

4 parallel streams (saturates multi-core paths):
```
iperf3 -c 192.168.0.1 -P 4
```

Reverse mode (server sends, client receives):
```
iperf3 -c 192.168.0.1 -R
```

Bidirectional simultaneously:
```
iperf3 -c 192.168.0.1 --bidir
```

Limit bandwidth (useful for UDP):
```
iperf3 -c 192.168.0.1 -u -b 500M
```

JSON output:
```
iperf3 -c 192.168.0.1 -J
```

---

## bandwhich

Live bandwidth by process and connection:
```
bandwhich
```

Specific interface only:
```
bandwhich -i eth0
```

No hostname resolution:
```
bandwhich -n
```

Raw bytes, no unit conversion:
```
bandwhich --raw
```

---

## wireguard-tools

Show all WireGuard interfaces:
```
wg show
```

Show a specific interface:
```
wg show wg0
```

Show full configuration of an interface:
```
wg showconf wg0
```

Bring a tunnel up (reads /etc/wireguard/wg0.conf):
```
sudo wg-quick up wg0
```

Bring a tunnel down:
```
sudo wg-quick down wg0
```

Generate a private key:
```
wg genkey
```

Generate a keypair in one step:
```
wg genkey | tee privatekey | wg pubkey > publickey
```

Derive a public key from an existing private key:
```
wg pubkey < privatekey
```

Add a peer at runtime:
```
sudo wg set wg0 peer <pubkey> allowed-ips 0.0.0.0/0 endpoint 1.2.3.4:51820
```

---

## mosh

Connect to a remote host:
```
mosh user@host
```

Specify a UDP port:
```
mosh --port 60001 user@host
```

Use a non-standard SSH port for the handshake:
```
mosh --ssh="ssh -p 2222" user@host
```

Disconnect: `Ctrl+^ .` (same gesture as SSH `~.`)

---

## nftables

Show the full active ruleset:
```
sudo nft list ruleset
```

List all tables:
```
sudo nft list tables
```

List a specific table:
```
sudo nft list table inet filter
```

List a specific chain:
```
sudo nft list chain inet filter input
```

Load a ruleset from file:
```
sudo nft -f /etc/nftables.conf
```

Add a rule at runtime:
```
sudo nft add rule inet filter input tcp dport 80 accept
```

JSON output (pipe to jq):
```
sudo nft -j list ruleset
```

Watch rule changes live:
```
sudo nft monitor
```

Flush all rules (clears everything):
```
sudo nft flush ruleset
```
