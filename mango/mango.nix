{ pkgs, config, ... }:

let
  mod1 = "SUPER";
  mod2 = "SUPER+SHIFT";
  mod3 = "SUPER+CTRL";
  mod4 = "SUPER+CTRL+SHIFT";
in

{
  imports = [
    ./fuzzel.nix
    ./mangobar.nix
    ./wlogout.nix
  ];

  home.packages = with pkgs; [
    lm_sensors
    brightnessctl
    wlrctl
    wlsunset
    ncdu
    bc
    wl-clipboard
    swaybg
    grim
    slurp
    satty
    wayfreeze
    swaylock-effects
    jq
    libnotify
    dunst
  ];

  xdg.configFile."swaylock".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mango/swaylock";
  xdg.configFile."dunst".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mango/dunst";
  home.file.".cache/bc_calc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mango/bc_calc";
  xdg.configFile."wlogout/style.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/mango/wlogout/style.css";

  programs.tofi.enable = true;

  services.cliphist = {
    enable = true;
    allowImages = true;
    extraOptions = [
      "-max-items"
      "500"
    ];
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "$HOME/.config/mango/scripts/sleep_monitors.sh";
        resumeCommand = "$HOME/.config/mango/scripts/wakeup_monitors.sh";
      }
      {
        timeout = 600;
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  wayland.windowManager.mango = {
    enable = true;
    autostart_sh = ''
      export XDG_SESSION_TYPE=wayland &
      export XDG_CURRENT_DESKTOP=wlroots &
      waybar &
      dunst &
      swaybg -i ~/Pictures/Wallpapers/wallpaper4.jpg -m fill

      systemctl --user import-environment PATH WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE &
      dbus-update-activation-environment --systemd PATH WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE &

      sleep 1
      systemctl --user restart xdg-desktop-portal.service xdg-desktop-portal-wlr.service &

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
      global_color = "0xc66b25ff";
      overlay_color = "0x282828ff";
      monitor_rule = [
        "make:Acer Technologies,model:Acer XFA240,width:1920,height:1080,refresh:144,x:0,y:20,primary:1"
        "make:Ancor Communications Inc,model:PA246,width:1920,height:1200,refresh:60,x:1920,y:0"
        "name:^eDP-1$,width:1920,height:1200,refresh:60,x:3840,y:0"
      ];
      window_rule = [
        "force_fake_maximize:1,app_id:codium"
        "is_floating:1, app_id:pavucontrol"
        "is_floating:1, app_id:nmtui"
        "is_floating:1, app_id:btop"
        "is_floating:1, app_id:ncdu"
        "is_floating:1, app_id:nix-search-tv"
        "is_floating:1, app_id:blueman-manager"
        "is_floating:1, app_id:mango-config-editor"
      ];
      bind = [
        "${mod1}, r, reload_config"
        "Alt, space, spawn, $HOME/.config/mango/scripts/launchers/applauncher.sh"
        "${mod1}, v, spawn, $HOME/.config/mango/scripts/launchers/cliphist.sh"
        "${mod1}, space, spawn, $HOME/.config/mango/scripts/launchers/hub.sh"
        "${mod1}, slash, spawn, $HOME/.config/mango/scripts/launchers/show_binds.sh"
        "${mod1}, comma, spawn, $HOME/.config/mango/scripts/launchers/notify_history.sh"
        "${mod1}, c, spawn, $HOME/.config/mango/scripts/launchers/calc.sh"
        "${mod1}, Return, spawn, kitty"
        "${mod1}, f, togglefloating"
        "${mod2}, f, toggle_all_floating"
        "${mod3}, n, spawn, kitty --class nix-search-tv -e $HOME/nixpkgs.sh"
        "${mod1}, b, spawn, firefox"
        "${mod3}, w, killclient"
        "${mod2}, s, spawn, $HOME/.config/mango/scripts/screenshot/copy-region.sh"
        "${mod3}, s, spawn, $HOME/.config/mango/scripts/screenshot/copy-window.sh"
        "${mod2}, n, spawn, $HOME/.config/mango/scripts/launchers/layout_switcher.sh"
        "${mod1}, n, spawn, $HOME/.config/mango/scripts/launchers/notes.sh"
        "${mod1}, h, focusdir, left"
        "${mod1}, j, focusdir, down"
        "${mod1}, k, focusdir, up"
        "${mod1}, l, focusdir, right"
        "${mod1}, bracketleft, focusmon, left"
        "${mod1}, bracketright, focusmon, right"
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
        "${mod3}, 1, tagmon, model:Acer XFA240"
        "${mod3}, 2, tagmon, model:PA246"
        "${mod3}, 3, tagmon, eDP-1"
        "${mod4}, p, spawn, wlogout"
      ];
      mousebind = [
        "${mod1}, btn_left, moveresize, curmove"
        "${mod1}, btn_right, moveresize, curresize"
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
      trap 'kill "$wp" 2>/dev/null || true; rm -f "$p"' EXIT
      read -r < "$p"
      g=$(slurp -d || true)
      if [ -z "$g" ]; then
        exit 1
      fi
      grim -g "$g" - | wl-copy
      kill "$wp" 2>/dev/null || true; rm -f "$p"
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
  xdg.configFile."mango/scripts/sleep_monitors.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      for m in $(wlr-randr | grep -v '^[[:space:]]' | awk '{print $1}'); do
          mmsg dispatch sleep_monitor,$m
      done
    '';
  };

  xdg.configFile."mango/scripts/wakeup_monitors.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      for m in $(wlr-randr | grep -v '^[[:space:]]' | awk '{print $1}'); do
          mmsg dispatch wakeup_monitor,$m
      done
    '';
  };
}
