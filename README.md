# letta-code-home

Letta Code's home on `mbp-2026`, following the agent home standard
(`/Users/claude/claude-guardian/docs/standards/agent-home.md`).

Letta Code 0.34.62 (`@letta-ai/letta-code`, Apache-2.0), a coding agent with its own memory, in **local mode**
(agents, chats and memory stay on this Mac). This repo is the **source** of its settings; `~/.letta` receives
copies (never links). Start it with `letta-code` in Terminal.

Letta Code writes its own `AGENTS.md`, context and memory itself, from its own docs (Reg, 2026-11-20). Its memory
is built in (MemFS); no extra memory engine.

| File | What it is |
|---|---|
| `settings/rules.py` | Writes the rules (`settings/settings.json`) from short lists |
| `settings/settings.json` | The rules (deny list) → set into `~/.letta/settings.json` |
| `settings/letta-code.sh` | Launcher → `~/.local/bin/letta-code` |
| `settings/zshenv-block.txt` | Self-update off + telemetry off for every shell → `~/.zshenv` |
| `install.sh` | Installs the three above as copies |
| `check.sh` | Health test |
| `scripts/backup-memory.sh` | Optional tool: copies the agents' memory into `memory/`; Letta decides how it backs up its memory |
| `uninstall.sh --dry-run` | Lists exactly what removal deletes (`FOOTPRINT.md`); deletes nothing in dry-run |
| `FOOTPRINT.md` | Every path this home owns, and the shared paths it must never delete |

## Limits, stated plainly

- **No OS sandbox.** Letta Code's rules stop its file tools (Read, Write, Edit, Grep, Glob, ListDir). A shell
  command it runs can reach anything the `claude` account can, as with Docker for every agent.
- Git: its file tools can't write into any repo's `.git` folder; it does git in its own repo with `git` commands, and
  its GitHub key only reaches `letta-code-home`. A `git commit` in another repo on this Mac is not stopped by the rules
  (shell command, as above). Repos inside hidden folders (e.g. `~/.codex/.tmp/…`) aren't covered by the `.git` rule.
- Hidden names: Letta matches rules in a way that skips names starting with a dot, so `settings/rules.py` adds
  patterns for them. Covered: every hidden file or folder one level deep inside a protected folder, and most two levels
  deep. Not covered: three hidden folders nested inside one protected folder (proof: `tests/rules-test.mjs`).
- A Grep or Glob started from a parent folder (e.g. `/Users/claude`) is checked on that folder, not on each file it
  walks through.
- OpenAI models get a patch tool (`ApplyPatch`) that the path rules do not check. The planned models (DeepSeek,
  LM Studio) use Write and Edit, which the rules do check.

Plan: `/Users/claude/claude-guardian/docs/plans/2026-11-15-letta-code-home.md`.
Settings research: `/Users/claude/claude-guardian/docs/research/2026-11-14-settings-map/letta-code.md`.
Security review: `/Users/claude/exos/security/letta-code/REVIEW.md`.
