{ pkgs, ... }: {
  imports = [ ];

  home.packages = with pkgs; [
    nodejs
    gcc
    bun
    air
    rustup
    go
    tailwindcss
    tailwindcss-language-server
  ];
}
