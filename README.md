# tmux maslias
tmux maslias is a simple and minimalist status bar theme for tmux

## Features
- Color indication when tmux prefix is pressed

## Installation
### TPM
- Install [TPM](https://github.com/tmux-plugins/tpm)
- Add the plugin:
```bash
- set -g @plugin 'maslias/tmux-maslias'
```
- Inside tmux, use the tpm install command: `prefix + I`

## Configuration
### Colors
```bash
set -g @tmux-maslias-color_normal '#ffbd5e'
set -g @tmux-maslias-color-status '#f1ff5e'
set -g @tmux-maslias-color-remote '#ff6e5e'
set -g @tmux-maslias-color-bg '0'
set -g @tmux-maslias-color-dark '#16181a'
set -g @tmux-maslias-color-white '#ffffff'
set -g @tmux-maslias-color-grey '#7b8496'

```
