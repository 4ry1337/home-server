{ config, lib, ... }:
with lib;
let
  cfg = config.features.cli.oh-my-posh;
in
{
  options.features.cli.oh-my-posh.enable = mkEnableOption "Enable Oh-My-Posh";

  config = mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        console_title_template = "{{ .Shell }} in {{ .Folder }}";
        version = 4;
        final_space = true;

        secondary_prompt = {
          template = "❯❯ ";
          foreground = "magenta";
          background = "transparent";
        };

        transient_prompt = {
          template = "❯ ";
          background = "transparent";
          foreground_templates = [
            "{{if gt .Code 0}}red{{end}}"
            "{{if eq .Code 0}}magenta{{end}}"
          ];
        };

        blocks = [
          {
            type = "prompt";
            alignment = "left";
            newline = true;
            segments = [
              {
                template = "{{ .HostName }}:{{.UserName}}:{{ .PWD }}";
                foreground = "blue";
                background = "transparent";
                type = "path";
                style = "plain";
                options.style = "folder";
              }
              {
                template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>";
                foreground = "p:grey";
                background = "transparent";
                type = "git";
                style = "plain";
                options = {
                  branch_icon = "";
                  commit_icon = "@";
                  fetch_status = true;
                };
              }
            ];
          }
          {
            type = "rprompt";
            overflow = "hidden";
            segments = [
              {
                template = "{{ .FormattedMs }}";
                foreground = "yellow";
                background = "transparent";
                type = "executiontime";
                style = "plain";
                options.threshold = 5000;
              }
            ];
          }
          {
            type = "prompt";
            alignment = "left";
            newline = true;
            segments = [
              {
                template = "❯";
                background = "transparent";
                type = "text";
                style = "plain";
                foreground_templates = [
                  "{{if gt .Code 0}}red{{end}}"
                  "{{if eq .Code 0}}magenta{{end}}"
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
