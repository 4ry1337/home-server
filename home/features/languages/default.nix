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
    (python314.withPackages(p: with p; [
      numpy
      pandas
      seaborn
      matplotlib
      jupyter
    ]))
  ];
}
