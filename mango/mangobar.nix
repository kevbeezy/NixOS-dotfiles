{ pkgs, inputs, ... }:

{
  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default;
    systemd = {
      enable = true;
      targets = [ "mango.target" ];
    };

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 5;
        #margin-bottom = 4;
        margin-left = 10;
        margin-right = 10;
        spacing = 0;

        modules-left = [
          "mango/workspaces"
          "custom/segment"
          "mango/layout"
          "custom/segment"
          "mango/window"
        ];

        modules-right = [
          "tray"
          "custom/segment"
          "clock#time"
          "custom/segment"
          "custom/nix"
          "custom/segment"
          "disk"
          "custom/segment"
          "custom/cpu"
          "custom/segment"
          "memory"
          "custom/segment"
          "bluetooth"
          "custom/segment"
          "pulseaudio"
          "custom/segment"
          "backlight"
          "custom/segment"
          #          "custom/segment"
          #          "clock#date"
          "network"
          "custom/segment"
          "power-profiles-daemon"
          "battery"
          "custom/segment"
          "custom/power"
        ];

        "mango/workspaces" = {
          format = "{icon}";
          hide-empty = false;
          tooltip = false;
          on-click = "activate";
          overview-label = "OVERVIEW";
        };

        "mango/layout" = {
          format = "{}";
          on-click = "bash ~/.config/mango/scripts/launchers/layout_switcher.sh";
        };

        "mango/window" = {
          format = "{}";
          max-length = 60;
          on-click = "bash ~/.config/mango/scripts/screenshot/copy-window.sh";
        };

        tray = {
          icon-size = 18;
          spacing = 8;
        };

        network = {
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󰈀 {ifname}";
          interval = 2;
          tooltip = true;
          tooltip-format = " {bandwidthDownBytes}  |   {bandwidthUpBytes}";
          format-disconnected = "󰤭";
          on-click = "kitty --class nmtui -e nmtui";
        };

        "custom/cpu" = {
          exec = ''
            bash -c '
              usage=$(top -bn1 | awk "/Cpu\(s\)/ {print \$2 + \$4}")
              temp=$(sensors | grep -E "Tctl|Core 0|temp1" | head -n 1 | awk "{print \$2}" | tr -d "+")
              printf "{\"text\": \"󰍛 %.0f%%\", \"tooltip\": \"CPU Temperature: %s\"}\n" "$usage" "$temp"
            '
          '';
          return-type = "json";
          interval = 2;
        };

        memory = {
          format = "󰘚 {percentage}%";
          interval = 2;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 {volume}%";
          format-icons = {
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        };

        backlight = {
          format = "󰃠 {percent}%";
          on-click = "pkill wlsunset || wlsunset -T 6500 -t 4000 &";
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
        };

        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          paths = "/";
          on-click = "kitty --class ncdu -e ncdu /";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-icons = [
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
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}nCPU driver: {cpu_driver}nPlatform driver: {platform_driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "󰗑";
            power-saver = "";
          };
        };

        bluetooth = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "blueman-manager";
        };

        #"clock#date" = {
        #  format = "󰃭 {:L%b %d · %A}";
        #};

        "clock#time" = {
          format = "󰥔 {:L%I:%M %p}";
          tooltip = true;
          tooltip-format = "󰃭 {:L%b %d · %A}";
        };

        "custom/power" = {
          format = "⏻ ";
          on-click = "wlogout";
          tooltip = false;
        };
        "custom/segment" = {
          format = " | ";
          tooltip = false;
        };
        "custom/nix" = {
          exec = ''
            bash -c '
            gen=$(readlink /nix/var/nix/profiles/system | cut -d- -f2)
            pkgs=$(nix-store -qR /run/current-system/sw | wc -l)
            printf "{\"text\": \" %s\", \"tooltip\": \"%s installed system packages\"}\n" "$gen" "$pkgs"
            '
          '';
          return-type = "json";
          format = "{}";
          interval = 3600;
          on-click = "kitty --class nix-search-tv -e $HOME/nixpkgs.sh";
        };

      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 14px;
        font-weight: bold;
        border: none;
        border-radius: 0px;
        min-height: 0;
        margin: 0px;
        padding: 0px;
      }

      window#waybar {
        background-color: #282828;
        border: 2px solid #83a598;
        color: #ebdbb2;
      }

      tooltip {
        background-color: #282828;
        border: 4px solid #C66B25;
        color: #ebdbb2;
      }


      /* Left-side Modules */
      #workspaces,
      #layout,
      #window {
        background-color: transparent;
        color: #ebdbb2;
        padding: 2px 8px;
      }

      #layout {
        color: #d3869b;
        font-size: 22px;
      }

      #workspaces button.active {
        background-color: transparent;
        color: #d65d0e;
        border-bottom: 2px solid #d65d0e;
      }

      #workspaces button {
        background-color: transparent;
        color: #98971a;
      }

      #workspaces button.empty {
        background-color: transparent;
        color: #ebdbb2;
      }

      #workspaces button.urgent {
        background-color: transparent;
        color: #cc241d;
        border-bottom: 2px solid #cc241d;
      }

      #workspaces button.hover {
        background-color: #ebdbb2;
        color: #282828;
      }

      /* Right-side System Modules with Underlines */
      #tray,
      #network,
      #custom-cpu,
      #memory,
      #pulseaudio,
      #backlight,
      #battery,
      #clock.date,
      #clock.time,
      #custom-power,
      #power-profiles-daemon{
        background-color: transparent;
        padding: 2px 6px;
        margin: 0px 4px;
      }

      #network {
        color: #8ec07c;
        border-bottom: 2px solid #8ec07c;
      }

      #custom-cpu {
        color: #fabd2f;
        border-bottom: 2px solid #fabd2f;
      }

      #memory {
        color: #d3869b;
        border-bottom: 2px solid #d3869b;

      }

      #pulseaudio {
        color: #fe8019;
        border-bottom: 2px solid #fe8019;
      }

      #backlight {
        color: #d3869b;
        border-bottom: 2px solid #d3869b;
      }

      #battery {
        color: #b8bb26;
        border-bottom: 2px solid #b8bb26;
      }

      #clock.date {
        color: #b8bb26;
        border-bottom: 2px solid #b8bb26;
      }

      #clock.time {
        color: #ebdbb2;
        border-bottom: 2px solid #ebdbb2;
      }

      #custom-power {
        color: #fb4934;
      }

      #custom-segment {
        color: #504945;
      }
      #custom-nix {
        color: #8ec07c;
        border-bottom: 2px solid #8ec07c;
      }

      #disk {
        color: #8ec07c;
        border-bottom: 2px solid #8ec07c;
      }

      #bluetooth {
        color: #458588;
        border-bottom: 2px solid #458588;
      }

      #power-profiles-daemon.performance {
        color: #fb4934;
        border-bottom: 2px solid #fb4934;
      }

      #power-profiles-daemon.balanced {
        color: #fabd2f;
        border-bottom: 2px solid #fabd2f;
      }

      #power-profiles-daemon.power-saver {
        color: #b8bb26;
        border-bottom: 2px solid #b8bb26;
      }
    '';
  };
}
