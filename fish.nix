{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx EDITOR nvim
      set -gx VISUAL nvim
    '';
    interactiveShellInit = ''
      set -g fish_greeting
      command clear
      fastfetch
    '';
    shellAliases = {
      ls = "ls -AFhl --color";
      gs = "git fetch; git status";
    };

    shellAbbrs = {
      gpr = "git pull --rebase";
    };

    functions = {
      ":q" = {
        description = "Exit fish like Vim";
        body = "exit";
      };
      opencode = {
        body = ''
          /usr/bin/bash -c '/home/joachim/.opencode/bin/opencode "$@"' -- $argv
        '';
      };
    };
  };
}
