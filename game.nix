{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    protonup-qt
    mangohud
    prismlauncher
    bottles
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        start = "${pkgs.systemd}/bin/systemctl --user stop swayidle.service";
        end = "${pkgs.systemd}/bin/systemctl --user start swayidle.service";
      };
    };
  };
}
