{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./plasma.nix
    inputs.areofyl-fetch.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    vim-full
    clang
    gnumake
    curl
    unzip
    nodejs
    clang-tools
  ];

  home.stateVersion = "24.05";

  # This creates a direct symlink to your local folder, bypassing the read-only Nix store
  home.file.".vim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vim/.vim";
  home.file.".config/nvim/colors".source = ./vim/colors;
  home.file.".gvimrc".source = ./vim/.gvimrc;
  home.file.".vimrc".source = ./vim/.vimrc;

  home.file.".config/fastfetch".source = ./fastfetch;
  home.file.".config/fish".source = ./fish;
  home.file.".config/kitty".source = ./kitty;
  home.file.".config/starship.toml".source = ./starship/starship.toml;
  home.file.".config/yazi".source = ./yazi;

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
      lsp.enable = true;
      treesitter.enable = true;
      autocomplete.nvim-cmp.enable = true;

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
        relativenumber = false;
        number = true;
      };

      luaConfigRC.myInitVim = ''
            vim.cmd('source ${./vim/init.vim}')
            vim.cmd("colorscheme noggyscheme")

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
      '';
    };
  };
  programs.tmux = {
    enable = true;
    extraConfig = ''
      bind -n M-h select-pane -L
      bind -n M-l select-pane -R
      bind -n M-k select-pane -U
      bind -n M-j select-pane -D
      set -g mouse on
    '';
  };
}
