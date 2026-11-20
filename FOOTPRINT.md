# Footprint of Letta Code's home

Everything removing this home deletes, and what it must never delete. `uninstall.sh` reads the two lists
between the `<!-- own -->` and `<!-- shared -->` markers below (one absolute path per line, starting `- `).

## Owned by this home (deleted on removal)

<!-- own -->
- /Users/claude/.local/bin/letta-code
- /Users/claude/.local/node/bin/letta
- /Users/claude/.local/node/lib/node_modules/@letta-ai/letta-code
- /Users/claude/.letta
<!-- /own -->

`~/.letta` holds the settings, the local agents and chats (`lc-local-backend`) and each agent's memory
(`lc-local-backend/memfs/<agent>/memory`). Run `scripts/backup-memory.sh` and push first: the memory copy in this
repo's `memory/` folder is what survives (P1).
Also removed on removal: the marked block in `/Users/claude/.zshenv` (`# >>> letta-code home` … `# <<< letta-code home`;
`uninstall.sh --yes` removes those lines only).
The `~/.local/node` entries come from `npm install -g` of 0.34.62 (2026-11-20); `~/Library` had no Letta entries
after install. The repo itself (`/Users/claude/letta-code`) is archived, not deleted (P1).

## Shared (never deleted when removing this home)

<!-- shared -->
- /Users/claude/.agents/skills
- /Users/claude/.local/node/bin/node
- /Users/claude/.local/node/bin/npm
- /Users/claude/.zshenv
<!-- /shared -->
