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
# This script symlinks the repository-root directories into every
# agent's workspace so relative paths resolve correctly regardless of
# what OpenClaw sets as cwd. Safe to re-run.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Repository-root directories agent protocols reference by relative path.
# raw_data/, inbox/, outbox/ are gitignored local-only directories, so a
# fresh clone won't have them yet.
ROOT_DIRS=(research knowledge raw_data inbox outbox tooling)

mkdir -p "$REPO_ROOT/raw_data" "$REPO_ROOT/inbox" "$REPO_ROOT/outbox"

shopt -s nullglob
agent_dirs=("$REPO_ROOT"/agents/*/)
shopt -u nullglob

if [ ${#agent_dirs[@]} -eq 0 ]; then
    echo "No agent directories found under agents/ — nothing to link." >&2
    exit 0
fi

for agent_dir in "${agent_dirs[@]}"; do
    agent_dir="${agent_dir%/}"
    agent_name="$(basename "$agent_dir")"

    for name in "${ROOT_DIRS[@]}"; do
        link="$agent_dir/$name"
        target="../../$name"

        if [ -L "$link" ]; then
            current_target="$(readlink "$link")"
            if [ "$current_target" = "$target" ]; then
                echo "ok      agents/$agent_name/$name -> $target"
            else
                echo "skip    agents/$agent_name/$name already links elsewhere ($current_target) — not touching" >&2
            fi
        elif [ -e "$link" ]; then
            echo "skip    agents/$agent_name/$name exists and is not a symlink — not touching" >&2
        else
            ln -s "$target" "$link"
            echo "linked  agents/$agent_name/$name -> $target"
        fi
    done
done
