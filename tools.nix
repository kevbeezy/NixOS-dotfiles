{ pkgs, ... }:

{
  home.packages = with pkgs; [
    clang
    gnumake
    nodejs
    clang-tools
    docker
    vscodium
    dos2unix
    cmake
    (writeShellScriptBin "code" ''
      exec codium "$@"
    '')
  ];

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
