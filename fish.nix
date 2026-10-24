{ ... }:

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
      neofetch

      # Configure built-in Git prompt to match Gruvbox
      set -g __fish_git_prompt_showdirtystate 1
      set -g __fish_git_prompt_showuntrackedfiles 1
      set -g __fish_git_prompt_color_branch d3869b # Gruvbox Purple
      set -g __fish_git_prompt_color_dirtystate fb4934 # Gruvbox Red
      set -g __fish_git_prompt_color_untrackedfiles fabd2f # Gruvbox Yellow
      set -g __fish_git_prompt_color_cleanstate 8ec07c # Gruvbox Aqua
      set -g __fish_git_prompt_color_prefix 98971a
      set -g __fish_git_prompt_color_suffix 98971a

      function fish_prompt
        set -l symbol "-"
        set -l delim ">"
        
        # Apply your requested hex colors
        set -l line_color (set_color 98971a)
        set -l text_color (set_color ebdbb2)
        set -l info_color $text_color

        if test (id -u) -eq 0
          set info_color (set_color -o red)
          set delim "#"
        end

        # Top line: Lines -> Text -> Lines -> Text -> Lines -> Git Prompt
        echo -s $line_color "┌──(" $info_color "$USER$symbol" (prompt_hostname) $line_color ")─[" $text_color (prompt_pwd -d 0) $line_color "]" (fish_git_prompt)
        
        # Bottom line
        echo -s $line_color "└─" $info_color "$delim " (set_color normal)
      end
    '';
    shellAliases = {
      ls = "eza -algF --header --extended --octal-permissions --group-directories-first --time-style=long-iso --color=always --git --icons=always";
      cat = "bat --style=full --theme=\"gruvbox-dark\" --wrap=character";
      gs = "git fetch; git status";
      neofetch = "fastfetch -c presets/examples/13";
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
