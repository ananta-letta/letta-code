# letta-code-home

Letta Code's home on `mbp-2026`, following the agent home standard
(`/Users/claude/claude-guardian/docs/standards/agent-home.md`).

Letta Code 0.34.62 (`@letta-ai/letta-code`, Apache-2.0), a coding agent with its own memory, in **local mode**
(agents, chats and memory stay on this Mac). This repo is the **source** of its settings; `~/.letta` receives
copies (never links). Start it with `letta-code` in Terminal.

| File | What it is |
|---|---|
| `settings/settings.json` | The rules (deny list) → set into `~/.letta/settings.json` |
| `settings/letta-code.sh` | Launcher → `~/.local/bin/letta-code` |
| `settings/zshenv-block.txt` | Self-update off + telemetry off for every shell → `~/.zshenv` |
| `install.sh` | Installs the three above as copies |
| `check.sh` | Health test |
| `scripts/backup-memory.sh` | Copies the agents' memory into `memory/` (git) |
| `uninstall.sh --dry-run` | Lists exactly what removal deletes (`FOOTPRINT.md`); deletes nothing in dry-run |
| `FOOTPRINT.md` | Every path this home owns, and the shared paths it must never delete |
| `AGENTS.md` | Letta Code's operating manual for this repo |

## Limits, stated plainly

- **No OS sandbox.** Letta Code's rules stop its file tools (Read, Write, Edit, Grep, Glob, ListDir). A shell
  command it runs can reach anything the `claude` account can, as with Docker for every agent.
- A Grep or Glob started from a parent folder (e.g. `/Users/claude`) is checked on that folder, not on each file it
  walks through.
- OpenAI models get a patch tool (`ApplyPatch`) that the path rules do not check. The planned models (DeepSeek,
  LM Studio) use Write and Edit, which the rules do check.
- Letta Code does not load `AGENTS.md` by itself; its built-in prompt tells it to read it early. Its always-loaded
  layer is its own memory.

Plan: `/Users/claude/claude-guardian/docs/plans/2026-11-15-letta-code-home.md`.
Settings research: `/Users/claude/claude-guardian/docs/research/2026-11-14-settings-map/letta-code.md`.
Security review: `/Users/claude/exos/security/letta-code/REVIEW.md`.
