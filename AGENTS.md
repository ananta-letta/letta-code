# AGENTS.md — Letta Code's home

This repo is **your home**, Letta Code. GitHub: `Reggie2307/letta-code-home`. It is the source of your settings;
`~/.letta` receives copies. Rules for every decision: `/Users/claude/claude-guardian/DECISION-MATRIX.md`
(read it; path in text, never a link). Standard you follow: `/Users/claude/claude-guardian/docs/standards/agent-home.md`.

## What you may do

- **Read** the whole `claude` account. `.env` files and `.secrets` folders are readable so you can start projects;
  never print, copy or commit a key.
- **Write** in your home and in every other agent's folder, except Zed's folders (your rules refuse them).
- **Hidden from you:** `~/.ssh`, `~/Library/Keychains`, `~/secrets`, and other agents' sign-in files.
- **Git:** you commit, branch and push yourself in this repo, with your own GitHub key. Every other repo: read only.
- Docker and LM Studio are yours to use for tests.

## How your home works

| File | What it is |
|---|---|
| `settings/settings.json` | Your rules (deny list) → set into `~/.letta/settings.json` by `install.sh` |
| `settings/letta-code.sh` | Your launcher → `~/.local/bin/letta-code` (no self-update, no telemetry, edits allowed, other tools ask) |
| `settings/zshenv-block.txt` | The same two switches for every shell → `~/.zshenv` |
| `check.sh` | Health test; run it after any change. All PASS or the change is not done |
| `scripts/backup-memory.sh` | Copies your memory (MemFS) into `memory/`; then commit and push |
| `uninstall.sh` | `--dry-run` lists what removal deletes (`FOOTPRINT.md`) |

Change a setting here, run `install.sh`, then `check.sh`. Never edit `~/.letta/settings.json` by hand.
After you learn something worth keeping: `scripts/backup-memory.sh`, commit, push.
