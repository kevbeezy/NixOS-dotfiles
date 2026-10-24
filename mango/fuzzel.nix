{ pkgs, ... }:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "kitty";
        icons-enabled = true;
        font = "JetBrainsMono Nerd Font:size=10";
        dpi-aware = "auto";
      };
      colors = {
        background = "504945ff";
        text = "ebdbb2ff";
        match = "b8bb26ff";
        selection = "ebdbb233";
        selection-text = "ebdbb2ff";
        selection-match = "b8bb26ff";
        border = "83a598ff";
      };
      border = {
        radius = 0;
      };
    };
  };

  xdg.configFile."mango/scripts/launchers/cliphist.sh" = {
    executable = true;
    text = ''
      cliphist list | fuzzel --dmenu --anchor bottom --width=100 --border-radius=0 | cliphist decode | wl-copy
    '';
  };

  xdg.configFile."mango/scripts/launchers/search.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      query=$(fuzzel --dmenu --lines=0 --anchor top --y=0 --width=70 --line-height=13 --inner-pad=0 --border-radius=0 --prompt="Search: ")

      if [ -n "$query" ]; then
        firefox "https://www.google.com/search?q=$query" &
        client_id=$(mmsg get all-clients | ${pkgs.jq}/bin/jq -r '.[] | select(.appid == "firefox") | .id' | head -n1)
        [ -n "$client_id" ] && mmsg dispatch focusid "client,$client_id"
      fi
    '';
  };

  xdg.configFile."mango/scripts/launchers/applauncher.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if pgrep -x "tofi-drun" > /dev/null; then
         pkill -x "tofi-drun"
         exit 0
      fi
      tofi-drun \
        --drun-launch true \
        --horizontal true \
        --num-results 1 \
        --min-input-width 1700 \
        --placeholder-text "$(printf '%.0s.' {1..250})" \
        --placeholder-color "#00000000" \
        --result-spacing 20 \
        --anchor top \
        --margin-top 5 \
        --width 1900 \
        --height 34 \
        --corner-radius 0 \
        --padding-top 4 \
        --padding-bottom 0 \
        --padding-left 15 \
        --padding-right 15 \
        --clip-to-padding false \
        --background-color "#282828" \
        --text-color "#ebdbb2" \
        --prompt-color "#ebdbb2" \
        --input-color "#ebdbb2" \
        --prompt-text "> " \
        --selection-color "#ebdbb2" \
        --selection-background "#282828" \
        --selection-match-color "#b8bb26" \
        --border-width 2 \
        --border-color "#83a598ff" \
        --outline-width 0 \
        --outline-color "#83a598ff" \
        --font "JetBrainsMono Nerd Font" \
        --font-size 12 \
        --require-match false
    '';
  };

  xdg.configFile."mango/scripts/launchers/layout_switcher.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      choice=$(printf "Tile\nScroller\nMonocle\nGrid\nDeck\nCenter Tile\nVertical Tile\nRight Tile\nVertical Scroller\nVertical Grid\nVertical Deck\nDwindle\nFair\nVertical Fair" | fuzzel --dmenu --lines=14 --width=20 --prompt="Layout: ")

      if [ -n "$choice" ]; then
        layout="''${choice,,}"
        layout="''${layout// /_}"
        mmsg dispatch "setlayout,$layout"
      fi
    '';
  };

  xdg.configFile."mango/scripts/launchers/notify_history.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      LOG_FILE="$HOME/.cache/dunst_history.log"
      if [ ! -f "$LOG_FILE" ]; then
          notify-send "Fuzzel" "No notification history found."
          exit 1
      fi
      CLEAR_CMD="󰃢 Clear History (clc)"
      selected=$( (echo "$CLEAR_CMD"; tac "$LOG_FILE") | fuzzel --dmenu -p "󰂚 History: " -l 15 --width 70 )
      if [ "$selected" = "$CLEAR_CMD" ]; then
          > "$LOG_FILE"
          notify-send "History Cleared" "Dunst notification logger has been erased."
      elif [ -n "$selected" ]; then
          echo -n "$selected" | wl-copy
          notify-send "Copied" "Notification copied to clipboard."
      fi
    '';
  };

  xdg.configFile."mango/scripts/launchers/show_binds.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      selected=$(awk '/bind = \[/,/\]/' ~/.dotfiles/mango/mango.nix | \
      grep -E '^[[:space:]]*"' | \
      sed -e 's/^[[:space:]]*"//' \
          -e 's/"[[:space:]]*,*[[:space:]]*$//' \
          -e 's/\''${mod1}/SUPER/g' \
          -e 's/\''${mod2}/SUPER+SHIFT/g' \
          -e 's/\''${mod3}/SUPER+CTRL/g' \
          -e 's/\''${mod4}/SUPER+CTRL+SHIFT/g' | \
      fuzzel --dmenu -p " ⌨ Keybinds: " -l 15 -w 70)
      if [ -n "$selected" ]; then
          kitty --class mango-config-editor -e nvim ~/.dotfiles/mango/mango.nix &
      fi
    '';
  };

  xdg.configFile."mango/scripts/launchers/calc.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      CACHE_DIR="$HOME/.cache/bc_calc"
      mkdir -p "$CACHE_DIR"
      EXT_FILE="$CACHE_DIR/extensions.bc"
      CONST_FILE="$CACHE_DIR/scientific_constants.bc"
      equation=$(fuzzel --dmenu -p "  Calc: " -l 0 </dev/null)
      if [ -z "$equation" ]; then
          exit 0
      fi
      if [[ "$equation" == "help" || "$equation" == "?" ]]; then
          kitty --class mango-config-editor -e nvim -R -O "$EXT_FILE" "$CONST_FILE" &
          exit 0
      fi
      result=$(echo "scale=10; $equation" | BC_LINE_LENGTH=0 bc -l -q "$EXT_FILE" "$CONST_FILE" 2>/dev/null | sed -e 's/^\./0./' -e 's/^-\./-0./' -e '/\./ s/0*$//' -e 's/\.$//')
      if [ -z "$result" ]; then
          notify-send "(bc): Error" "Not a valid syntax"
      else
          echo -n "$result" | wl-copy
          notify-send -- "(bc): $result" "Sent to clipboard"
      fi
    '';
  };

  xdg.configFile."mango/scripts/launchers/notes.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      NOTES_DIR="$HOME/Documents/Notes"
      mkdir -p "$NOTES_DIR"
      existing_notes=$(find "$NOTES_DIR" -maxdepth 1 -name "*.md" -printf "%T@ %f\n" | sort -rn | cut -d' ' -f2- | sed 's/\.md$//')
      options="[New Note]\n$existing_notes"
      selection=$(echo -e "$options" | sed '/^$/d' | fuzzel --dmenu -p "  Note: " -l 15)
      if [ -z "$selection" ]; then
          exit 0
      fi
      if [[ "$selection" == "[New Note]" ]]; then
          custom_name=$(echo "[Date]" | fuzzel --dmenu -p "  Name: " -l 0)
          if [ -z "$custom_name" ]; then
              exit 0
          fi
          if [[ "$custom_name" == "[Date]" ]]; then
              note_name=$(date +"%m-%d-%Y")
          else
              note_name="$custom_name"
          fi
      else
          note_name="$selection"
      fi
      filepath="$NOTES_DIR/$note_name.md"
      kitty --class mango-config-editor -e nvim "$filepath" &
    '';
  };
  xdg.configFile."mango/scripts/launchers/hub.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      LAUNCHER_DIR="$HOME/.config/mango/scripts/launchers"
      raw_scripts=$(find -L "$LAUNCHER_DIR" -maxdepth 1 -name "*.sh" -executable -printf "%f\n" | sed 's/\.sh$//')
      options=""
      for base in $raw_scripts; do
          if [[ "$base" == "hub" ]]; then
              continue
          fi
          case "$base" in
              calc) proper_name="Calculator" ;;
              applauncher) proper_name="App Launcher" ;;
              cliphist) proper_name="Clipboard History" ;;
              layout_switcher) proper_name="Layout Switcher" ;;
              notes) proper_name="Notes" ;;
              notify_history) proper_name="Notification History" ;;
              search) proper_name="Search" ;;
              show_binds) proper_name="Show Binds" ;;
              *) 
                  spaced="''${base//_/ }"
                  proper_name=$(echo "$spaced" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
                  ;;
          esac
          options="$options$proper_name\n"
      done
      selection=$(echo -e "$options" | sed '/^$/d' | sort | fuzzel --dmenu -p "  Hub: " -l 10)
      if [ -z "$selection" ]; then
          exit 0
      fi
      case "$selection" in
          "Calculator") file_base="calc" ;;
          "App Launcher") file_base="applauncher" ;;
          "Clipboard History") file_base="cliphist" ;;
          "Layout Switcher") file_base="layout_switcher" ;;
          "Notes") file_base="notes" ;;
          "Notification History") file_base="notify_history" ;;
          "Search") file_base="search" ;;
          "Show Binds") file_base="show_binds" ;;
          *) 
              file_base=$(echo "$selection" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
              ;;
      esac
      target_script="$LAUNCHER_DIR/$file_base.sh"
      if [ -x "$target_script" ]; then
          "$target_script" &
      fi
    '';
  };
}
