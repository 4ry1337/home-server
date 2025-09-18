{ config, lib, pkgs, ... }:
with lib;
let cfg = config.features.cli.zsh;
in {
  options.features.cli.zsh.enable =
    mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      loginExtra = ''
        export NIX_PATH="nixpkgs=channel:nixos-unstable"
        export NIX_LOG=info
      '';
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";
      shellAliases = {
        vim = "nvim";
        ls = "ls -p -G";
        la = "ls -A";
        ll = "eza -l -g --icons";
        lla = "ll -a";
        c = "clear";
        ".." = "cd ..";
        mkdir = "mkdir -p";
      };
      oh-my-zsh = {
        enable = true;
        plugins =
          [ "git" "sudo" "aws" "kubectl" "kubectx" "rust" "command-not-found" ];
      };
      plugins = [
        {
          # will source zsh-autosuggestions.plugin.zsh
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
          file = "share/zsh-completions/zsh-completions.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
          file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];
    };
  };
}
