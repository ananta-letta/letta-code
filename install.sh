#!/bin/bash
# Installs Letta Code's home settings from this repo as plain copies (never links). Run check.sh afterwards.
# - ~/.letta/settings.json: Letta keeps its own state in this file, so only our "permissions.deny" list is set
#   (replaced by the source list); every other key, incl. Reg's "always allow" choices, is kept.
# - ~/.local/bin/letta-code: the launcher.
# - ~/.zshenv: the marked block (added once; nothing else in the file is touched).
set -euo pipefail
R=/Users/claude/letta-code
H=/Users/claude
for f in settings.json letta-code.sh zshenv-block.txt; do
  [ -s "$R/settings/$f" ] || { echo "REFUSED: $R/settings/$f is missing or empty"; exit 1; }
done

mkdir -p "$H/.letta"
S=$H/.letta/settings.json
[ ! -L "$S" ] || { echo "REFUSED: $S is a link"; exit 1; }
python3 - "$R/settings/settings.json" "$S" <<'PY'
import json, os, sys
src, dst = sys.argv[1], sys.argv[2]
ours = json.load(open(src))["permissions"]["deny"]
cur = json.load(open(dst)) if os.path.exists(dst) and os.path.getsize(dst) else {}
cur.setdefault("permissions", {})["deny"] = ours
tmp = dst + ".new"
with open(tmp, "w") as f:
    json.dump(cur, f, indent=2); f.write("\n")
os.chmod(tmp, 0o600); os.replace(tmp, dst)
PY
echo "installed permissions.deny ($(python3 -c "import json;print(len(json.load(open('$S'))['permissions']['deny']))") rules) into $S"

launcher=$H/.local/bin/letta-code
[ ! -L "$launcher" ] || { echo "REFUSED: $launcher is a link"; exit 1; }
mkdir -p "$H/.local/bin"
cp "$R/settings/letta-code.sh" "$launcher.new"
chmod 755 "$launcher.new"
mv "$launcher.new" "$launcher"
echo "installed $launcher"

if grep -qF '# >>> letta-code home' "$H/.zshenv" 2>/dev/null; then
  echo "kept ~/.zshenv block (already there)"
else
  { echo; cat "$R/settings/zshenv-block.txt"; } >> "$H/.zshenv"
  echo "added block to ~/.zshenv"
fi
