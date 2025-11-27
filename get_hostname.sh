#!/usr/bin/env bash

# Get the current pane's process tree and check for SSH
pane_pid=$(tmux display-message -p '#{pane_pid}')

# Function to get all child PIDs recursively
get_all_pids() {
    local pid=$1
    echo "$pid"
    pgrep -P "$pid" 2>/dev/null | while read -r child; do
        get_all_pids "$child"
    done
}

# Get all processes in this pane
all_pids=$(get_all_pids "$pane_pid")

# Look for SSH process and extract hostname
for pid in $all_pids; do
    cmd=$(ps -p "$pid" -o command= 2>/dev/null)
    if echo "$cmd" | grep -q '^ssh '; then
        # Extract hostname from SSH command
        # Handles: ssh user@host, ssh host, ssh -p port host, etc.
        host=$(echo "$cmd" | sed -n 's/.*ssh[^@]*@\([^ ]*\).*/\1/p')
        if [ -z "$host" ]; then
            # Try without @ (direct hostname)
            host=$(echo "$cmd" | sed -n 's/.*ssh \([^-][^ ]*\).*/\1/p')
        fi
        if [ -n "$host" ]; then
            # Check if it's an IP address (contains only digits and dots)
            if echo "$host" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'; then
                # It's an IP address, show it as-is
                echo "$host"
            else
                # It's a hostname, show short version (first part before dot)
                echo "$host" | cut -d. -f1
            fi
            exit 0
        fi
    fi
done

# Not in SSH, show local hostname
hostname -s
