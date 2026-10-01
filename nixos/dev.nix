# Claude Code Remote Control, always on, as an unprivileged user (no sudo, no access to admin's files).
# First run: `sudo -u dev tmux attach -t claude` to log in.
{pkgs, ...}: {
  users.users.dev = {
    isNormalUser = true;
    packages = with pkgs; [claude-code gh];
  };

  systemd.tmpfiles.rules = ["d /home/dev/code 0755 dev users -"];

  systemd.services.claude-remote = {
    wantedBy = ["multi-user.target"];
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "forking";
      User = "dev";
      WorkingDirectory = "/home/dev/code";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s claude 'bash -lc \"claude remote-control\"'";
      Restart = "always";
      RestartSec = 30;
    };
  };
}
