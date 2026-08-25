{ pkgs, ... }:

{
  systemd.user.services.rclone-gdrive = {
    Unit = {
      Description = "Rclone mount for Google Drive";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      Type = "notify";
      # Create the mount directory before starting
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/GoogleDrive";

      # Mount command with full VFS caching for LibreOffice compatibility
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount gdrive: %h/GoogleDrive \
          --vfs-cache-mode full \
          --config %h/.config/rclone/rclone.conf
      '';

      # Safely unmount on stop
      ExecStop = "/run/wrappers/bin/fusermount -u %h/GoogleDrive";

      # Auto-restart if the network drops
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
