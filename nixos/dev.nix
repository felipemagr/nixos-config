# Claude Code Remote Control, always on, as an unprivileged user (no sudo, no access to admin's files).
# First run: `sudo -u dev tmux attach -t claude`, log in with `claude`, then run `claude remote-control`.
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
      Type = "oneshot";
      RemainAfterExit = true;
      User = "dev";
      WorkingDirectory = "/home/dev/code";
      ExecStart = "${pkgs.tmux}/bin/tmux new-session -d -s claude 'bash -lc \"claude remote-control; exec bash -l\"'";
      ExecStop = "${pkgs.tmux}/bin/tmux kill-server";
    };
  };
}
