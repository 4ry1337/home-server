{ pkgs, ... }: {
  imports = [ ./zsh.nix ./fzf.nix ./fastfetch.nix ./tmux.nix ./neovim.nix ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraOptions = [ "-l" "--icons" "--git" "-a" ];
  };

  programs.bat = { enable = true; };

  home.packages = with pkgs; [
    gh
    ghq
    lazygit
    oh-my-posh
    tree
    fzf
    fd
    jq
    ripgrep
    zip
    unzip

    # network
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses
  ];
}
