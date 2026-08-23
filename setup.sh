#!/usr/bin/env bash
# Prepares a freshly cloned copy of this template for use.
#
# OpenClaw ties an agent's tool working directory to its workspace
# directory (the place it loads AGENTS.md/SOUL.md/IDENTITY.md from) —
# the two cannot be configured separately (openclaw/openclaw#32637,
# closed as not planned). Each agent's workspace is agents/<name>/,
# two levels below the repository root, so without help every relative
# path an agent uses (research/, knowledge/, ...) would resolve against
# its own agent directory instead of the repository.
#
# Symlinking the repository root into each workspace (the previous
# approach here) does not survive contact with OpenClaw's sandbox:
# read/write tools reject a path that resolves outside the workspace
# boundary, symlink or not — OpenClaw shipped a fix (2026.2.26) closing
# exactly that escape route. Plain `../../` relative traversal hits the
# same boundary for the same reason, so it isn't a viable fallback either.
#
# Instead, this script writes a PROJECT_ROOT file into each agent's own
# workspace, containing the repository's absolute path. Reading a file
# from inside your own workspace is never blocked by any sandbox
# config, so this works regardless of sandboxing state. Each agent's
# AGENTS.md instructs it to read this file once and resolve every
# relative path in the governing protocols against it, rather than
# assuming its working directory is the repository root. PROJECT_ROOT
# is deployment-specific — the same clone can live at a different
# absolute path on a different machine — so it's gitignored, not
# committed. Safe to re-run.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$REPO_ROOT/raw_data" "$REPO_ROOT/inbox" "$REPO_ROOT/outbox"

shopt -s nullglob
agent_dirs=("$REPO_ROOT"/agents/*/)
shopt -u nullglob

if [ ${#agent_dirs[@]} -eq 0 ]; then
    echo "No agent directories found under agents/ — nothing to do." >&2
    exit 0
fi

for agent_dir in "${agent_dirs[@]}"; do
    agent_dir="${agent_dir%/}"
    agent_name="$(basename "$agent_dir")"

    printf '%s' "$REPO_ROOT" > "$agent_dir/PROJECT_ROOT"
    echo "wrote   agents/$agent_name/PROJECT_ROOT -> $REPO_ROOT"
done
