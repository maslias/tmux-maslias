#!/usr/bin/env bash

# Takes pane_pid as argument (more efficient than calling tmux internally)
pane_pid="${1:-$(tmux display-message -p '#{pane_pid}')}"

# Exit quickly if no pane_pid (during tmux startup)
[[ -z "$pane_pid" || "$pane_pid" == "0" ]] && { hostname -s 2>/dev/null || echo "local"; exit 0; }

# Get all descendant PIDs efficiently (without recursive subshells)
get_all_pids() {
    local pid=$1
    local pids="$pid"
    local children

    children=$(pgrep -P "$pid" 2>/dev/null)
    for child in $children; do
        pids="$pids $(get_all_pids "$child")"
    done

    echo "$pids"
}

# Timeout after 0.5 seconds to prevent blocking tmux startup
all_pids=$(timeout 0.5 bash -c "$(declare -f get_all_pids); get_all_pids $pane_pid" 2>/dev/null)

# Fallback if timeout or error
[[ -z "$all_pids" ]] && { hostname -s 2>/dev/null || echo "local"; exit 0; }

# Look for SSH process and extract hostname
for pid in $all_pids; do
    cmd=$(ps -p "$pid" -o command= 2>/dev/null) || continue

    if [[ "$cmd" =~ ^ssh[[:space:]] ]]; then
        # Extract hostname: handles ssh user@host, ssh host, ssh -p port host, etc.
        if [[ "$cmd" =~ @([^[:space:]]+) ]]; then
            host="${BASH_REMATCH[1]}"
        elif [[ "$cmd" =~ ssh[[:space:]]+([^-][^[:space:]]+) ]]; then
            host="${BASH_REMATCH[1]}"
        fi

        if [[ -n "$host" ]]; then
            # Show full IP or short hostname
            if [[ "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                echo "$host"
            else
                echo "${host%%.*}"
            fi
            exit 0
        fi
    fi
done

# Not in SSH, show local hostname
hostname -s
