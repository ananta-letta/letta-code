# NAMING.md — agent naming & the two-lineage model

Binding convention for every Letta agent we launch (terminal **or** OSS-UI). The point is
**comparative, continuous monitoring**: run the two lineages side by side, watch them against
evals/observability, and harvest what we learn back into the enhanced lineage.

## The two canonical lineages

| Agent name | Lineage | What it is |
|---|---|---|
| **`letta-org`** | upstream / original | The pristine Letta Code, as shipped. Baseline for comparison. |
| **`ananta-letta`** | enhanced fork | Our fork: extra skills, tools, plugins, and context systems. |

- **Both write into the same App Server** (`letta server --backend local --listen ws://127.0.0.1:4500`), like any other Letta agent — the server is the single hub that sees both.
- **`letta-org`** carries the upstream/original identity; **`ananta-letta`** carries the enhanced identity.

## Naming rule (applies to every future agent)

Every Letta agent name carries a **lineage prefix**:
- `letta-org-<name>` → belongs to the upstream/original lineage.
- `ananta-letta-<name>` → belongs to the enhanced lineage.

So a future research agent on the enhanced side is `ananta-letta-research`, and the same role on the pristine side is `letta-org-research`.

## Why this exists — the learning loop

We launch a `letta-org` agent (baseline skills) and an `ananta-letta` agent (new tools/skills/plugins) on the
same task/project, let the App Server + evals + observability (set up later) measure both, and adopt the winning
configuration into the enhanced lineage. **Every launched agent is a data point** — its performance feeds back into
what tools, skills, and plugins we add to each lineage. This is EXOS "everything harvested" applied to agent runtime,
not just code.

## Not yet built (dependencies, in order)

1. A defined eval/observability harness (to measure org-vs-enh).
2. Enforcement of this naming on every launch (terminal helper + OSS-UI practice).
3. The harvest step: routing per-agent results back into lineage improvements.
