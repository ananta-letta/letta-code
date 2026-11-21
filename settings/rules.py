#!/usr/bin/env python3
"""Writes settings/settings.json (Letta Code's deny rules) from the short lists below. Edit the lists, run
`python3 settings/rules.py`, then install.sh and check.sh (which runs tests/rules-test.mjs).

Why generated: Letta matches rules with minimatch's default options, where "**" skips names starting with a dot
(found by test T3, 2026-11-21). So each protected folder gets extra patterns naming dot entries explicitly. A pattern with
two "**" around hidden names never matches in minimatch 10.2.6 (tested), so the patterns use one "**" and fixed steps:
every path with no or one hidden level is covered, two hidden levels when at most three folders sit between them, three
or more hidden levels are not (README "Limits"). Proven by tests/rules-test.mjs.
"""
import json, os

H = "/Users/claude"
# Zed's folders: read-only to every agent but Zed (Reg, 2026-11-14)
ZED_DIRS = ["Zed_Monorepo", ".config/zed", "Library/Application Support/Zed", "Library/Caches/Zed", "Library/Logs/Zed",
            ".codex-zed", "Applications/Delta.app", "Library/Application Support/Delta"]
ZED_FILES = ["Library/Preferences/dev.zed.Zed.plist", "Library/Preferences/com.zed-industries.delta.plist"]
# Hidden from every agent (Reg, 2026-11-14; Letta's key folders 2026-11-20)
HIDDEN_DIRS = [".ssh", "Library/Keychains", "secrets", ".letta/lc-local-backend/providers", ".letta/lc-local-backend/secrets"]
HIDDEN_FILES = [".codex/auth.json", ".codex-zed/auth.json", ".claude.json", ".claude.json.backup"]
# Other repos' git folders: no file-tool writes (git itself runs as a command in its own repo)
GIT = [f"{H}/**/.git", f"{H}/**/.git/**", f"{H}/**/.git/.*", f"{H}/**/.git/*/.*", f"{H}/**/.git/*/*/.*", f"{H}/**/.git/.*/**"]


def tree(d):
    """The folder itself and everything under it, hidden entries included (see the note at the top)."""
    x = f"{H}/{d}"
    pats = [x, f"{x}/**", f"{x}/**/.*", f"{x}/**/.*/**"]
    for j in range(4):
        g = f"{x}/**/.*/" + "*/" * j + ".*"
        pats += [g, g + "/**"]
    return pats


rules = []
for t in ("Write", "Edit"):
    rules += [f"{t}({p})" for d in ZED_DIRS for p in tree(d)]
    rules += [f"{t}({H}/{f})" for f in ZED_FILES]
    rules += [f"{t}({p})" for p in GIT]
for t in ("Read", "Grep", "Glob", "ListDir"):
    rules += [f"{t}({p})" for d in HIDDEN_DIRS for p in tree(d)]
for t in ("Read", "Grep"):
    rules += [f"{t}({H}/{f})" for f in HIDDEN_FILES]

out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "settings.json")
with open(out, "w") as f:
    json.dump({"permissions": {"deny": rules}}, f, indent=2)
    f.write("\n")
print(f"{len(rules)} rules written to {out}")
