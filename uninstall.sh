#!/bin/bash
# Removes Letta Code's home: exactly the "own" paths in FOOTPRINT.md, never a "shared" one, plus the marked
# block in ~/.zshenv. --dry-run (default) only prints. Real removal needs --yes and Reg's OK.
set -euo pipefail
R=/Users/claude/letta-code
Z=/Users/claude/.zshenv
mode=${1:---dry-run}
section() { sed -n "/^<!-- $1 -->\$/,/^<!-- \/$1 -->\$/p" "$R/FOOTPRINT.md" | sed -n 's/^- //p'; }
own=$(section own); shared=$(section shared)
[ -n "$own" ] || { echo "REFUSED: no owned paths in FOOTPRINT.md"; exit 1; }
while read -r p; do
  while read -r s; do
    case "$p/" in "$s"/*|"$s/") echo "REFUSED: $p is shared ($s)"; exit 1;; esac
    case "$s/" in "$p"/*) echo "REFUSED: $p contains shared $s"; exit 1;; esac
  done <<< "$shared"
done <<< "$own"
while read -r p; do
  if [ "$mode" = --yes ]; then [ -e "$p" ] || [ -L "$p" ] && rm -rf "$p" && echo "removed $p"
  else echo "would remove $p"; fi
done <<< "$own"
if grep -qF '# >>> letta-code home' "$Z" 2>/dev/null; then
  if [ "$mode" = --yes ]; then
    sed -i '' '/^# >>> letta-code home/,/^# <<< letta-code home/d' "$Z" && echo "removed letta-code block from $Z"
  else echo "would remove lines '# >>> letta-code home' to '# <<< letta-code home' from $Z"; fi
fi
