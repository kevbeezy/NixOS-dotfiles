{ pkgs, inputs, ... }:

let
  mod1 = "SUPER";
  mod2 = "SUPER+SHIFT";
  mod3 = "SUPER+CTRL";
  mod4 = "SUPER+CTRL+SHIFT";
in
{
  home.packages = with pkgs; [
    wl-clipboard
    swaybg
    grim
    slurp
    satty
    wayfreeze
    jq
    libnotify
  ];

  programs.fuzzel = {
    enable = true;
  };

  programs.wlogout = {
    enable = true;
  };

  services.dunst = {
    enable = true;
  };

  services.mangobar = {
    enable = true;
    systemdTarget = "mango.target";
    settings = {
      modules-left = [
        "workspaces"
        "layout"
        "window"
      ];
      modules-right = [
        "hideclients"
        "tray"
        "network"
        "cpu"
        "memory"
        "pulseaudio"
        "backlight"
        "battery"
        "clock#date"
        "clock#time"
        "custom/power"
      ];
      workspaces = {
        hide-empty = false;
        overview-label = "OVERVIEW";
        on-click = "activate";
        on-click-right = "toggle";
      };
      layout = {
        format = "{}";
      };
      window = {
        format = "{}";
        on-click = "bash ~/.config/mango/scripts/screenshot/copy-window.sh";
      };
      network = {
        format = "{icon} {ifname}";
        format-wifi = "{signal} {ssid}";
        format-disconnected = "{icon}";
        icon-wifi = "󰖩";
        icon-ethernet = "󰈀";
        icon-disconnected = "󰖪";
        signal-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
        format-alt = "↓{down} ↑{up}";
      };
      hideclients = {
        format = " {}";
      };
      cpu = {
        format = " {load}%";
      };
      memory = {
        format = " {}%";
      };
      backlight = {
        format = "{icon} {percent}%";
        icons = [
          "󰃚"
          "󰃛"
          "󰃜"
          "󰃝"
          "󰃞"
          "󰃟"
        ];
      };
      pulseaudio = {
        format = "{icon} {volume}% {bt}";
        format-muted = "󰝟 {volume}% {bt}";
        icons = [
          "󰝟"
          "󰕿"
          "󰕾"
        ];
      };
      battery = {
        format = "{icon} {percent}% {ac}";
        icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        icon-charging = "󰂄";
        icon-full = "󰁹";
        icon-ac = "";
        hide-on-ac = true;
      };
      "clock#date" = {
        format = " {:L%b %d · %A}";
      };
      "clock#time" = {
        format = " {:L%I:%M %p}";
      };
      tray = {
        icon-size = 25;
        spacing = 10;
      };
      "custom/power" = {
        format = "󰐥";
        on-click = "wlogout";
      };
    };
  };

  xdg.configFile."mangobar/style.css".text = ''
    * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 14px;
    }
    * {
        color: #ebdbb2;
        background-color: #504945;
        padding: 0px 10px;
        margin: 5px 1px;
        border-radius: 100px;
    }

    #bar {
        background: none;
        margin: 5px 10px;
    }
    #bar.sel {
        background: none;
    }

    #tags {
        padding: 0px 13px;
        margin: 0px 2px;
    }

    #tags.active {
        background-color: #83a598;
        color: #1b1a1a;
    }
    #tags.occupied {
        background-color: #504945;
        color: #ebdbb2;
    }
    #tags.urgent {
        background-color: #fb4934;
        color: #1b1a1a;
    }
    #tags.empty {
        background-color: #201b14;
        color: #ebdbb2;
    }

    /* Overview mode */
    #overview {
        background-color: #83a598;
        color: #1b1a1a;
    }

    /* Layout symbol */
    #layout {
        background-color: #bd788a;
        color: #111111;
        min-width: 34px;
        margin: 5px 5px;
    }

    /* Window title */
    #title {
        background-color: #bd788a;
        color: #111111;
    }

    /* Right-side system modules */
    #clock {
        background-color: #c4b595;
        color: #1b1a1a;
    }
    /* Date module (clock#date), separate from time */
    #clock.date {
        background-color: #b8bb26;
        color: #1b1a1a;
    }
    #cpu {
        padding: 0px 15px;
        background-color: #c4b595;
        color: #1b1a1a;
    }
    #mem {
        background-color: #83a598;
        color: #1b1a1a;
    }
    #brightness {
        background-color: #d3869b;
        color: #1b1a1a;
    }
    #volume {
        background-color: #d19e27;
        color: #1b1a1a;
    }
    #network {
        background-color: #b8bb26;
        color: #1b1a1a;
    }
    /* Network link states: swap the icon/colors per connection type. */
    #network.wifi {
        background-color: #83a598;
        color: #1b1a1a;
    }
    #network.ethernet {
        background-color: #b8bb26;
        color: #1b1a1a;
    }
    #network.disconnected {
        background-color: #fb4934;
        color: #1b1a1a;
    }
    #keymode {
        background-color: #83a598;
        color: #1b1a1a;
    }
    #keyboardlayout {
        background-color: #bd788a;
        color: #1b1a1a;
    }

    /* Custom modules use #custom-<name> (e.g. custom/power -> #custom-power) */
    #custom-power {
        margin: 0px 5px;
        background-color: #90AD9D;
        color: #000000;
    }

    #tray {
        background-color: #6B645A;
        padding: 0px 15px;
    }

    menu {
        background-color: #201B14;
        border-color: #ebdbb2;
        border-radius: 10px;
        font-size: 14px;
    }
    menuitem {
        color: #ebdbb2;
    }
    menuitem:hover {
        color: #1b1a1a;
        background-color: #b8bb26;
    }
  '';

  wayland.windowManager.mango = {
    enable = true;
    autostart_sh = ''
      mangobar &
      dunst &
      swaybg -i ~/Pictures/Wallpapers/wallpaper4.jpg
    '';
    settings = {
      repeat_rate = 25;
      repeat_delay = 300;
      blur = 1;
      blur_optimized = 1;
      trackpad_natural_scrolling = 1;
      tap_to_click = 1;
      tap_and_drag = 1;
      circle_layout = "grid,scroller,tile,monocle,dwindle";
      bind = [
        "${mod1}, r, reload_config"
        "Alt, space, spawn, fuzzel"
        "${mod1}, Return, spawn, kitty"
        "${mod3}, w, killclient"
        "${mod2}, s, spawn, $HOME/.config/mango/scripts/screenshot/copy-region.sh"
        "${mod3}, s, spawn, $HOME/.config/mango/scripts/screenshot/copy-window.sh"
        "${mod1}, n, switch_layout"
        "${mod1}, h, focusdir, left"
        "${mod1}, j, focusdir, down"
        "${mod1}, k, focusdir, up"
        "${mod1}, l, focusdir, right"
        "${mod2}, h, move_client, left"
        "${mod2}, j, move_client, down"
        "${mod2}, k, move_client, up"
        "${mod2}, l, move_client, right"
        "${mod3}, h, resizewin, -20, 0"
        "${mod3}, j, resizewin, 0, +20"
        "${mod3}, k, resizewin, 0, -20"
        "${mod3}, l, resizewin, +20, 0"
        "${mod1}, 1, view, 1"
        "${mod1}, 2, view, 2"
        "${mod1}, 3, view, 3"
        "${mod1}, 4, view, 4"
        "${mod1}, 5, view, 5"
        "${mod1}, 6, view, 6"
        "${mod1}, 7, view, 7"
        "${mod1}, 8, view, 8"
        "${mod1}, 9, view, 9"
        "${mod2}, 1, tag, 1"
        "${mod2}, 2, tag, 2"
        "${mod2}, 3, tag, 3"
        "${mod2}, 4, tag, 4"
        "${mod2}, 5, tag, 5"
        "${mod2}, 6, tag, 6"
        "${mod2}, 7, tag, 7"
        "${mod2}, 8, tag, 8"
        "${mod2}, 9, tag, 9"
      ];
    };
  };

  xdg.configFile."mango/scripts/screenshot/copy-region.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      p=$(mktemp -u).fifo; mkfifo "$p"
      wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
      read -r < "$p"
      g=$(slurp -d)
      if [ -z "$g" ]; then 
        kill "$wp" 2>/dev/null; rm -f "$p"; exit 1
      fi
      grim -g "$g" - | wl-copy
      kill "$wp" 2>/dev/null; rm -f "$p"
      notify-send "Screenshot Copied" "Selected region saved to clipboard." -t 2000
    '';
  };

  xdg.configFile."mango/scripts/screenshot/copy-window.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail
      g=$(mmsg get focusing-client | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')
      if [ -z "$g" ] || [ "$g" = "null,null nullxnull" ]; then 
        exit 1
      fi
      p=$(mktemp -u).fifo; mkfifo "$p"
      wayfreeze --after-freeze-timeout 100 --after-freeze-cmd "echo > $p" & wp=$!
      read -r < "$p"
      grim -g "$g" - | wl-copy
      kill "$wp" 2>/dev/null; rm -f "$p"
      notify-send "Screenshot Copied" "Active window saved to clipboard." -t 2000
    '';
  };
}
