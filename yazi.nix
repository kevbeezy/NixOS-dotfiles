{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      log.enabled = true;
      mgr = {
        show_hidden = true;
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "g"
            "p"
          ];
          run = "cd ~/projects";
          desc = "Go to ~/projects";
        }
        {
          on = [
            "g"
            "l"
          ];
          run = "cd ~/localsend";
          desc = "Go to ~/localsend";
        }
        {
          on = [
            "g"
            "t"
          ];
          run = "cd ~/.local/share/Trash/files";
          desc = "Go to Trash";
        }
        {
          on = [
            "g"
            "n"
          ];
          run = "cd ~/.dotfiles";
          desc = "Go to nix dotfiles";
        }
      ];
    };

    initLua = ''
      require("zoxide"):setup {
        update_db = true
      }
    '';
  };
}
