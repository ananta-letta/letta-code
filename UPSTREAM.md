# UPSTREAM.md — how we pull from `letta-ai/letta-code`

`ananta-letta/letta-code` is a **fork** of `letta-ai/letta-code`. This file is the
merge-and-test discipline that keeps our version *ours* while staying current with
upstream. It is binding; every agent working here reads it before touching `main`.

## The two-version model (Reg's design)

- **`upstream`** = `https://github.com/letta-ai/letta-code.git` — pristine, the thing Letta ships.
- **`origin`** = `https://github.com/ananta-letta/letta-code.git` — our fork, where our enhancements live.
- **`main`** = our integration branch. Upstream updates land here **only after review + test**.

## Rule — never auto-merge

Pulling from upstream is always deliberate:

1. `git fetch upstream` — get the latest pristine source.
2. Merge it into a review branch **behind a test gate** (`git fetch upstream && git checkout -b upstream-review upstream/main` then merge into a test branch).
3. Run our full test suite (`./check.sh` and the fork's own tests). **Nothing is adopted unless it passes our tests.**
4. If green → merge into `main` by hand. If red → **stop**, report what broke to Reg in plain English, and decide with him: fix it, skip it, or wait.

This is the DECISION-MATRIX's **G2 "pinned, never auto-updated"** made mechanical.

## Roles

- **Tutor (agent)** implements the fetch/merge/test and **pings Reg** whenever an upstream update is ready for review.
- **Reg** makes the **strategic approve/reject call** on every upstream update — "does this advance our vision?" — because that product judgment is his to own.

## Why a fork and not a dependency

We are building *our own* agent harness/runtime — "Claude Code, but with our own context-management and memory systems, one integrated self-improving/self-evolving harness." A fork means we can diverge (App Server + agent + OSS-UI as one integrated desktop+CLI app) without being hostage to upstream's release schedule. The cost we accept is a **recurring review decision per upstream update** — which is exactly what makes it *ours*.
