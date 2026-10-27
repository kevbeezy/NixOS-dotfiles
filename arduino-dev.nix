{ pkgs, ... }:

{
  users.users.joachim.extraGroups = [
    "dialout"
    "uucp"
  ];

  services.udev.packages = [ pkgs.platformio-core.udev ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
    ];
  };
}
