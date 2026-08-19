{ config, pkgs, ... }:

{
  imports = [
    ./plasma.nix
  ];

  home.packages = with pkgs; [
    vim-full
    clang
    gnumake
    curl
    unzip
    nodejs
  ];

  home.stateVersion = "24.05";

  # This creates a direct symlink to your local folder, bypassing the read-only Nix store
  home.file.".vim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/.vim";
  home.file.".vimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/.vimrc";
  home.file.".gvimrc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/.gvimrc";
  home.file.".config/nvim/init.vim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/init.vim";

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
}
