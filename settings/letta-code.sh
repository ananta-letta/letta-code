#!/bin/sh
# Starts Letta Code the home's way: no self-update, no telemetry, edits auto-approved (other tools ask).
# Installed as a copy to ~/.local/bin/letta-code by install.sh. Source: /Users/claude/letta-code/settings/letta-code.sh
export DISABLE_AUTOUPDATER=1 LETTA_CODE_TELEM=0 DO_NOT_TRACK=1
L=/Users/claude/.local/node/bin/letta
case " $* " in
  *" --permission-mode"*|*" --yolo"*|*" --version"*|*" -v "*|*" --help"*|*" -h "*) exec "$L" "$@" ;;
esac
exec "$L" --permission-mode acceptEdits "$@"
