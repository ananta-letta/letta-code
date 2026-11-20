#!/bin/bash
# Copies every local Letta Code agent's memory (MemFS Markdown, without its .git) into this repo's memory/
# folder, so the memory lives in git (P1, P2: an engine's store exports to source in a neutral format).
# Letta Code itself runs this, then commits and pushes letta-code-home.
set -euo pipefail
R=/Users/claude/letta-code
SRC=${LETTA_LOCAL_BACKEND_DIR:-/Users/claude/.letta/lc-local-backend}/memfs
[ -d "$SRC" ] || { echo "no local agent memory yet ($SRC)"; exit 0; }
n=0
for m in "$SRC"/*/memory; do
  [ -d "$m" ] || continue
  agent=$(basename "$(dirname "$m")")
  mkdir -p "$R/memory/$agent"
  rsync -a --delete --exclude .git --no-links "$m/" "$R/memory/$agent/"
  echo "copied $m -> memory/$agent"
  n=$((n+1))
done
echo "agents backed up: $n"
