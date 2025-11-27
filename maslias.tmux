#!/usr/bin/env bash

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
color_normal=$(get_tmux_option "@tmux-maslias-color_normal" '#ffbd5e')
color_status=$(get_tmux_option "@tmux-maslias-color-status" '#f1ff5e')
color_remote=$(get_tmux_option "@tmux-maslias-color-remote" '#ff6e5e')
color_bg=$(get_tmux_option "@tmux-maslias-color-bg" '0')
color_dark=$(get_tmux_option "@tmux-maslias-color-dark" '#16181a')
color_white=$(get_tmux_option "@tmux-maslias-color-white" '#ffffff')
color_grey=$(get_tmux_option "@tmux-maslias-color-grey" '#7b8496')


window_status_separator=$("#[fg=$color_white]  •  ")
window_status_current_format=$(" #[fg=$color_white]#W #[fg="$color_normal",nobold,nodim] ")
window_status_format=$(" #[fg=$color_grey]#W #[fg="$color_grey",nobold,nodim] ")

status_left=$("#[fg=$color_bg,bold,nodim]#{?client_prefix,#[bg=$color_status],#[bg=$color_normal]} TMX #[bg=$color_bg]#[fg="$color_white",nobold,nodim] #S")
status_right=$("#[fg=$color_white]󰢹 #{hostname} #[fg=$color_bg]#{?client_prefix,#[bg=$color_status],#[bg=$color_status]}   ")

tmux set-option status-bg default
tmux set-option status-style bg=default

tmux set-option status-left-length 200
tmux set-option status-right-length 200
tmux set-option status-justify "absolute-centre"

tmux set-option message-style "fg=$color_normal,bg=$color_bg"
tmux set-option message-command-style "fg=$color_white,bg=$color_normal"


tmux set-option pane-border-style "fg=$color_dark"
tmux set-option pane-active-border-style "fg=$color_normal"
tmux set-option display-panes-active-colour "$color_white"
tmux set-option display-panes-colour "$color_normal"

tmux set-window-option -g window-status-separator "$window_status_separator"
tmux set-option -g window-status-format "$window_status_format"
tmux set-option -g window-status-current-format "$window_status_current_format"
tmux set-option -g status-left "$status_left"
tmux set-option -g status-right "$status_right"
