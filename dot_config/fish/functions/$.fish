# =============================================================================
# Bash Daemon Interface
# Execute commands through bash daemon
# =============================================================================

function \$ -d "Execute command through bash daemon"
  if not test -f /tmp/bash_daemon.pid; or not kill -0 (cat /tmp/bash_daemon.pid) 2>/dev/null
    echo "Starting bash daemon..."
    bash bash_daemon &
    sleep 0.5
  end

  echo "$argv" > /tmp/bash_daemon_pipe &

  while read -l line
    if test "$line" = "###DONE###"
        break
    end

    echo $line
  end < /tmp/bash_daemon_out
end
