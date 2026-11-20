#!/bin/bash
# Health test for Letta Code's home (agent home standard). Read-only. PASS/FAIL per check; exit 0 only if all pass.
H=/Users/claude
R=$H/letta-code
G=$H/claude-guardian/settings
pass=0; fail=0
ok()  { echo "PASS  $1"; pass=$((pass+1)); }
bad() { echo "FAIL  $1"; fail=$((fail+1)); }
t()   { if "${@:2}" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }

pin()        { awk '$1=="letta-code"{print $2}' $G/pins.txt; }
installed()  { $H/.local/node/bin/letta --version | awk '{print $1}'; }
pinned()     { [ -n "$(pin)" ] && [ "$(installed)" = "$(pin)" ]; }
desk_row()   { awk -F'\t' '$1=="letta-code"' $G/updates.tsv | grep -q .; }
shell_env()  { [ "$(zsh -c 'echo $DISABLE_AUTOUPDATER/$LETTA_CODE_TELEM')" = "1/0" ]; }
local_only() { [ -z "$(zsh -c 'echo ${LETTA_API_KEY:-}${LETTA_BASE_URL:-}')" ] && ! grep -qE 'api\.letta\.com|LETTA_API_KEY' $H/.letta/settings.json; }
same()       { [ -s "$1" ] && cmp -s "$1" "$2"; }
launcher()   { same $R/settings/letta-code.sh $H/.local/bin/letta-code && [ -x $H/.local/bin/letta-code ] && [ ! -L $H/.local/bin/letta-code ]; }
launch_ver() { [ -n "$(pin)" ] && [ "$($H/.local/bin/letta-code --version | awk '{print $1}')" = "$(pin)" ]; }
deny_same()  { python3 -c "import json,sys;a=json.load(open('$R/settings/settings.json'))['permissions']['deny'];b=json.load(open('$H/.letta/settings.json'))['permissions']['deny'];sys.exit(a!=b)"; }
zshenv_ok()  { awk '/^# >>> letta-code home/{f=1} f{print} /^# <<< letta-code home/{exit}' $H/.zshenv | cmp -s - $R/settings/zshenv-block.txt; }
into_repo() { # prints link targets that sit inside a repo folder /Users/claude/<name>/ (one with its own .git)
  find "$1" -type l -exec readlink {} \; 2>/dev/null | while read -r tg; do
    case "$tg" in "$H"/?*) ;; *) continue;; esac
    top=${tg#$H/}; top=${top%%/*}; [ -n "$top" ] && [ -e "$H/$top/.git" ] && echo "$tg"; done; }
links_ok()   { [ -z "$(find $R -path $R/.git -prune -o -type l -print)" ] && [ -z "$(into_repo $H/.letta)" ]; }
no_secrets() { ! grep -rIlE --exclude-dir=.git '(sk-[A-Za-z0-9_-]{20,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,})' $R; }
mem_plain()  { [ -z "$(find $R/memory -name .git 2>/dev/null)" ]; }
git_clean()  { [ -d $R/.git ] && [ -z "$(git -C $R ls-files | grep -E '(^|/)(\.letta/|lc-local-backend|auth\.json|.*\.sqlite.*|.*\.db$)')" ]; }

t "Letta Code installed at its pinned version (pins.txt letta-code)" pinned
t "the updates desk lists letta-code (settings/updates.tsv)" desk_row
t "every new shell has self-update off and telemetry off (~/.zshenv block)" shell_env
t "~/.zshenv block equals source settings/zshenv-block.txt" zshenv_ok
t "launcher ~/.local/bin/letta-code equals source, a real file" launcher
t "launcher starts the pinned version" launch_ver
t "installed rules (~/.letta/settings.json permissions.deny) equal source" deny_same
t "local mode only: no Letta Cloud key or address" local_only
t "no links in the repo; none from ~/.letta into a repo" links_ok
t "no keys in the repo's files" no_secrets
t "memory copies are plain files (no .git inside memory/)" mem_plain
t "repo exists and tracks no settings, chats, databases or sign-ins" git_clean

echo
echo "TOTAL: $pass passed, $fail failed"
[ $fail -eq 0 ]
