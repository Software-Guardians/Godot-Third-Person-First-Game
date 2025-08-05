#!/bin/sh
echo -ne '\033c\033]0;3d first game\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/ball_kick_game.x86_64" "$@"
