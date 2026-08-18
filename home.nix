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
  home.file.".vim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/.vim";
  home.file.".vimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/.vimrc";
  home.file.".gvimrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/.gvimrc";
  home.file.".config/nvim/init.vim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/projects/vim/init.vim";

  programs.git = {
    enable = true;
    userName = "kevbeezy";
    userEmail = "kevbeezy3@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
}
