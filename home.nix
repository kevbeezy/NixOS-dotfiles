{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:

let
  toggleFile = /home/joachim/.nixos-toggles.json;
  defaultToggles = {
    tools = true;
    arduino = false;
    game = false;
    mango = true;
    plasma = false;
  };
  toggles =
    if builtins.pathExists toggleFile then
      builtins.fromJSON (builtins.readFile toggleFile)
    else
      defaultToggles;
in

{
  imports = [
    inputs.areofyl-fetch.homeManagerModules.default
    ./rclone.nix
    ./yazi.nix
    ./fish.nix
    ./vis.nix
  ]
  ++ lib.optional toggles.tools ./tools.nix
  ++ lib.optional toggles.mango ./mango/mango.nix
  ++ lib.optional toggles.plasma ./plasma.nix;

  home.packages = with pkgs; [
    kitty
    libreoffice
    vim-full
    curl
    unzip
  ];

  home.stateVersion = "24.05";

  home.username = "joachim";
  home.homeDirectory = "/home/joachim";

  # This creates a direct symlink to your local folder, bypassing the read-only Nix store
  home.file.".vim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vim/.vim";
  home.file.".config/nvim/colors".source = ./vim/colors;
  home.file.".gvimrc".source = ./vim/.gvimrc;
  home.file.".vimrc".source = ./vim/.vimrc;
  home.file."nixpkgs.sh".source = ./scripts/nixpkgs.sh;
  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/kitty";
  xdg.configFile."fastfetch".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fastfetch";

  home.file.".config/vis" = {
    source = ./vis;
    recursive = true;
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk.enable = true;

  programs = {
    rclone.enable = true;
    mpv.enable = true;
    ripgrep.enable = true;
    bat.enable = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "kevbeezy";
        email = "kevbeezy3@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.fetch = {
    enable = true;
    separator = "~";
    labelColor = "blue";
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        theme = {
          activeBorderColor = [
            "blue"
            "bold"
          ];
          inactiveBorderColor = [
            "black"
          ];
        };
      };
    };
  };

  programs.nvf = {
    enable = true;
    settings.vim = {
      lsp = {
        enable = true;
        inlayHints.enable = true;
        lspSignature.enable = true;
      };
      treesitter.enable = true;
      autocomplete.nvim-cmp.enable = true;
      utility.ccc.enable = true;

      languages = {
        enableTreesitter = true;
        enableFormat = true;
        clang.enable = true;
        bash.enable = true;
        nix = {
          enable = true;
          format.enable = true;
          format.type = [ "nixfmt" ];
        };
      };

      options = {
        relativenumber = true;
        number = true;
      };

      luaConfigRC.myInitVim = ''
                    vim.keymap.set("n", "<leader>vfn", "<cmd>edit ~/.dotfiles/<CR>", { desc = "Open dotfiles directory" })
                    vim.cmd('cabbrev nix ~/.dotfiles/')
                    vim.cmd('source ${./vim/init.vim}')
                    vim.cmd("colorscheme gruvbox")
                    vim.cmd([[
                      highlight Normal guibg=none ctermbg=none
                      highlight NonText guibg=none ctermbg=none
                      highlight NormalFloat guibg=none ctermbg=none
                      highlight NormalNC guibg=none ctermbg=none
                      highlight SignColumn guibg=none ctermbg=none
                      highlight EndOfBuffer guibg=none ctermbg=none
                      highlight LineNr guibg=none ctermbg=none
                      highlight FoldColumn guibg=none ctermbg=none
                    ]])
                    vim.diagnostic.config({
                      signs = false,
                      underline = true,
                      update_in_insert = false,
                      virtual_text = false,
                      severity_sort = true,
                    })
                    vim.api.nvim_create_user_command(
                'Format',
                function()
                    vim.lsp.buf.format({ async = true })
                    print("Formatted via LSP!")
                end,
                { desc = "Format current buffer with LSP" }
                    )
        vim.api.nvim_create_user_command(
                        'NixRebuild',
                        function()
                            -- Save all open buffers first
                            vim.cmd('wa')
                            -- Open a split terminal at the bottom
                            vim.cmd('botright 15split')
                            -- Run the exact command from your alias
                            vim.fn.termopen('find $HOME/.dotfiles -name "*.nix" -exec nixfmt {} + && sudo nixos-rebuild switch --flake $HOME/.dotfiles#joachim')
                            -- Enter insert mode automatically for the sudo password prompt
                            vim.cmd('startinsert')
                        end,
                        { desc = "Save and rebuild NixOS configuration" }
                    )
      '';
    };
  };

  programs.nix-search-tv = {
    enable = true;
    enableTelevisionIntegration = true;
  };
}
