// Proves Letta Code's deny rules (settings/settings.json) cover what they must, with the glob library Letta ships with
// (minimatch, same version as bundled in letta.js) and Letta's own matching: rule "Tool(pattern)", absolute pattern,
// minimatch(path, pattern) with default options (so "**" skips names starting with a dot: hence the ".*" patterns).
// Run: node tests/rules-test.mjs   (check.sh runs it). Exit 0 only if every case is as expected.
import { readFileSync } from "node:fs";
const M = "/Users/claude/.local/node/lib/node_modules/@letta-ai/letta-code/node_modules/minimatch/dist/esm/index.js";
const { minimatch } = await import(M);
const R = "/Users/claude/letta-code";
const deny = JSON.parse(readFileSync(`${R}/settings/settings.json`, "utf8")).permissions.deny;
const H = "/Users/claude";
const denied = (tool, path) => deny.some((r) => {
  const m = r.match(/^([^(]+)\(([\s\S]+)\)$/);
  return m && m[1] === tool && minimatch(path, m[2]);
});
const mustDeny = [
  ["Write", `${H}/Zed_Monorepo/.letta-t3.txt`], ["Edit", `${H}/Zed_Monorepo/notes.md`],
  ["Write", `${H}/Zed_Monorepo/.git/config`], ["Write", `${H}/Zed_Monorepo/a/.b/c`], ["Write", `${H}/Zed_Monorepo/.a/.b/c`],
  ["Write", `${H}/.config/zed/settings.json`], ["Edit", `${H}/.config/zed/.hidden`],
  ["Write", `${H}/Library/Application Support/Zed/db/.x/y`], ["Write", `${H}/Library/Caches/Zed/a`],
  ["Write", `${H}/Library/Logs/Zed/Zed.log`], ["Write", `${H}/.codex-zed/sessions/a.jsonl`],
  ["Write", `${H}/.codex-zed/.codex-global-state.json`], ["Write", `${H}/Applications/Delta.app/Contents/Info.plist`],
  ["Write", `${H}/Library/Application Support/Delta/.x`], ["Write", `${H}/Library/Preferences/dev.zed.Zed.plist`],
  ["Edit", `${H}/Library/Preferences/com.zed-industries.delta.plist`],
  ["Write", `${H}/codex/.git/HEAD`], ["Write", `${H}/a/.git/refs/.x`], ["Write", `${H}/a/.git/.x/y`], ["Write", `${H}/codex/.git/.letta-t4.txt`], ["Edit", `${H}/a/b/.git/refs/heads/main`],
  ["Read", `${H}/secrets/letta-canary.txt`], ["Read", `${H}/secrets/.env`], ["Read", `${H}/secrets/.a/.b`], ["Read", `${H}/secrets/a/.b/c/.d/e`], ["Write", `${H}/Zed_Monorepo/x/.b/y/z/.c`],
  ["Grep", `${H}/secrets`], ["ListDir", `${H}/secrets`], ["Glob", `${H}/secrets/.x`],
  ["Read", `${H}/.ssh/id_ed25519`], ["Read", `${H}/.ssh/.hidden`], ["Read", `${H}/Library/Keychains/login.keychain-db`],
  ["Read", `${H}/.letta/lc-local-backend/providers/auth.json`], ["Read", `${H}/.letta/lc-local-backend/providers/.x`],
  ["Read", `${H}/.letta/lc-local-backend/secrets/local-agent-secrets.json`],
  ["Read", `${H}/.codex/auth.json`], ["Read", `${H}/.codex-zed/auth.json`], ["Read", `${H}/.claude.json`],
  ["Read", `${H}/.claude.json.backup`], ["Grep", `${H}/.claude.json`],
];
const mustAllow = [
  ["Write", `${H}/letta-code/tests/out/t1.txt`], ["Write", `${H}/letta-code/.letta/settings.json`],
  ["Write", `${H}/agent-zero/tests/.letta-t2.txt`], ["Edit", `${H}/codex/README.md`], ["Write", `${H}/Zed_Monorepo2/x`],
  ["Read", `${H}/deep-notebook/.secrets/keys.env`], ["Read", `${H}/some-project/.env`], ["Read", `${H}/.codex/config.toml`],
  ["Read", `${H}/.letta/settings.json`], ["Read", `${H}/Zed_Monorepo/AGENTS.md`], ["Read", `${H}/codex/.git/HEAD`],
];
let bad = 0;
for (const [t, p] of mustDeny) if (!denied(t, p)) { console.log(`NOT DENIED  ${t}(${p})`); bad++; }
for (const [t, p] of mustAllow) if (denied(t, p)) { console.log(`WRONGLY DENIED  ${t}(${p})`); bad++; }
console.log(`rules-test: ${mustDeny.length + mustAllow.length - bad}/${mustDeny.length + mustAllow.length} as expected (${deny.length} rules)`);
process.exit(bad ? 1 : 0);
