#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

get_tmux_option() {
  local option=$1
  local default_value="$2"

  local option_value
  option_value=$(tmux show-options -gqv "$option")

  if [ "$option_value" != "" ]; then
    echo "$option_value"
    return
  fi
  echo "$default_value"
}

# colors
color_normal=$(get_tmux_option "@tmux-maslias-color-normal" '#ffbd5e')
color_status=$(get_tmux_option "@tmux-maslias-color-status" '#f1ff5e')
color_remote=$(get_tmux_option "@tmux-maslias-color-remote" '#ff6e5e')
color_bg=$(get_tmux_option "@tmux-maslias-color-bg" '0')
color_dark=$(get_tmux_option "@tmux-maslias-color-dark" '#16181a')
color_white=$(get_tmux_option "@tmux-maslias-color-white" '#ffffff')
color_grey=$(get_tmux_option "@tmux-maslias-color-grey" '#7b8496')


window_status_separator="#[fg=$color_white]  •  "
window_status_current_format=" #[fg=$color_white]#W #[fg=$color_normal,nobold,nodim]󰾂 "
window_status_format=" #[fg=$color_grey]#W #[fg=$color_grey,nobold,nodim]󰒅 "

status_left="#[fg=$color_bg,bold,nodim]#{?client_prefix,#[bg=$color_status],#{?#{==:#{pane_current_command},ssh},#[bg=$color_remote],#[bg=$color_normal]}} TMX #[bg=$color_bg]#[fg=$color_grey,nobold,nodim] #S"
status_right="#[fg=$color_white]  #($CURRENT_DIR/get_hostname.sh #{pane_pid}) #[fg=$color_bg]#{?client_prefix,#[bg=$color_status],#{?#{==:#{pane_current_command},ssh},#[bg=$color_remote],#[bg=$color_normal]}}   "

tmux set-option -g status-bg default
tmux set-option -g status-style bg=default

tmux set-option -g status-interval 2
tmux set-option -g status-left-length 200
tmux set-option -g status-right-length 200
tmux set-option -g status-justify "centre"

tmux set-option -g message-style "fg=$color_normal,bg=$color_bg"
tmux set-option -g message-command-style "fg=$color_white,bg=$color_normal"


tmux set-option -g pane-border-style "fg=$color_dark"
tmux set-option -g pane-active-border-style "fg=$color_normal"
tmux set-option -g display-panes-active-colour "$color_white"
tmux set-option -g display-panes-colour "$color_normal"

tmux set-window-option -g window-status-separator "$window_status_separator"
tmux set-option -g window-status-format "$window_status_format"
tmux set-option -g window-status-current-format "$window_status_current_format"
tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"

# Force status-style to default bg (must be after all other plugins)
tmux set-option -g status-style "bg=default"

# Set up hook to force status style and refresh after session is created
tmux set-hook -g after-new-session 'set-option -g status-style "bg=default" ; refresh-client -S'

# Force an immediate refresh for current session
tmux refresh-client -S

