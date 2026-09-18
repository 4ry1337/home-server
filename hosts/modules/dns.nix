{ ... }:
{
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };
  # Disable systemd dns resolver
  services.resolved = {
    enable = false;
    settings = {
      Resolve = {
        Domains = [ "~." ];
        FallbackDNS = [ ]; # Empty to prevent bypass
        DNSOverTLS = "true";

        # github.com/systemd/systemd/issues/10579
        # dnssec = "allow-downgrade";
        DNSSEC = "false";
      };
    };
  };
  systemd.services = {
    unbound.stopIfChanged = false;
    adguardhome = {
      after = [
        "network.target"
        "unbound.service"
      ];
      requires = [ "unbound.service" ];
    };
  };
  services = {
    unbound = {
      enable = true;
      settings = {
        remote-control.control-enable = true;
        server = {
          # When only using Unbound as DNS, make sure to replace 127.0.0.1 with your ip address
          # When using Unbound in combination with pi-hole or Adguard, leave 127.0.0.1, and point Adguard to 127.0.0.1:PORT
          interface = [ "127.0.0.1" ]; # "::1"
          port = 5335;
          access-control = [
            "127.0.0.1 allow"
            "192.168.0.0/24 allow"
          ];
          log-servfail = true; # explicitly logs *why* a SERVFAIL happened
          tcp-reuse-timeout = 10000;
          # Based on recommended settings in https://docs.pi-hole.net/guides/dns/unbound/#configure-unbound
          harden-glue = true;
          harden-dnssec-stripped = true;
          use-caps-for-id = false;
          prefetch = true;
          edns-buffer-size = 1232;
          hide-identity = true;
          hide-version = true;
        };
        forward-zone = [
          {
            name = ".";
            forward-tls-upstream = "yes";
            forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
              "1.0.0.1@853#cloudflare-dns.com"

              # "9.9.9.9#dns.quad9.net"
              # "149.112.112.112#dns.quad9.net"
            ];
          }
          {
            name = "erg.kz.";
            forward-addr = [
              "10.5.2.4"
              "10.5.2.5"
            ];
          }
        ];
      };
    };
    adguardhome = {
      enable = true;
      host = "0.0.0.0";
      port = 3005;
      mutableSettings = true;
      openFirewall = true;
      settings = {
        http = {
          address = "127.0.0.1:3005";
        };
        dns = {
          bind_host = "0.0.0.0";
          bind_port = 53;
          upstream_dns = [
            "[/ts.net/]100.100.100.100" # Tailscale MagicDNS for *.ts.net
            "127.0.0.1:5335"
          ];
          bootstrap_dns = [ "127.0.0.1:5335" ];
          cache_ttl_max = 3600;
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
          filters_update_interval = 12;

          parental_enabled = false;
          safe_search.enabled = false;
        };
        filters =
          map
            (url: {
              enabled = true;
              url = url;
            })
            [
              # EasyList
              "https://easylist.to/easylist/easylist.txt" # Base filter
              "https://easylist.to/easylist/easyprivacy.txt" # Privacy protection
              # AdGuard
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_2_Base/filter.txt" # BASE
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_3_Spyware/filter.txt" # Spyware
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_17_TrackParam/filter.txt" # Url Trackers
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_4_Social/filter.txt" # Social
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_14_Annoyances/filter.txt" # Annoyance
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_25_Mail_Tracking_Protection/filter.txt" # Mail Tracking
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_11_Mobile/filter.txt" # Mobile
              # Hagezi
              "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/adblock/ultimate.txt" # Hagezi Ultimate
              # uBlock
              "https://github.com/uBlockOrigin/uAssets/blob/master/filters/filters.txt"
              "https://github.com/uBlockOrigin/uAssets/blob/master/filters/filters-2026.txt"
              "https://github.com/uBlockOrigin/uAssets/blob/master/filters/filters-general.txt"
              "https://github.com/uBlockOrigin/uAssets/blob/master/filters/filters-mobile.txt"
              # CIS/Russian
              "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_1_Russian/filter.txt" # CIS/Russian
              "https://raw.githubusercontent.com/Zalexanninev15/NoADS_RU/main/ads_list_extended_plus.txt"
              # Misc
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/LegitimateURLShortener.txt"
              "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/privacy_essentials.txt"
              "https://raw.githubusercontent.com/yokoffing/filterlists/refs/heads/main/annoyance_list.txt"
              "https://raw.githubusercontent.com/DandelionSprout/adfilt/refs/heads/master/BrowseWebsitesWithoutLoggingIn.txt"
              "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
              "https://raw.githubusercontent.com/hoshsadiq/adblock-nocoin-list/master/nocoin.txt"
              "https://raw.githubusercontent.com/iam-py-test/my_filters_001/refs/heads/main/antitypo.txt"
            ];
      };
    };
  };
}
