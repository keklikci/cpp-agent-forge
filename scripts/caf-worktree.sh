#!/bin/sh

set -eu

usage() {
    printf '%s\n' \
        'Usage: scripts/caf-worktree.sh create <task-id> [base-branch]' \
        '       scripts/caf-worktree.sh list' \
        '       scripts/caf-worktree.sh remove <task-id>'
}

repo_root=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
worktree_root=${CAF_WORKTREE_ROOT-"$repo_root/../.caf-worktrees"}
prefix=${CAF_BRANCH_PREFIX-codex/}

slugify() {
    printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9._-' '-'
}

if [ "$#" -lt 1 ]; then
    usage >&2
    exit 2
fi

case "$1" in
    create)
        [ "$#" -ge 2 ] && [ "$#" -le 3 ] || { usage >&2; exit 2; }
        task_slug=$(slugify "$2")
        base_branch=${3-main}
        branch=${prefix}${task_slug}
        worktree="$worktree_root/$task_slug"
        mkdir -p "$worktree_root"
        if [ -e "$worktree" ]; then
            printf 'worktree already exists: %s\n' "$worktree" >&2
            exit 1
        fi
        git -C "$repo_root" worktree add -b "$branch" "$worktree" "$base_branch"
        printf 'created task=%s branch=%s path=%s\n' "$task_slug" "$branch" "$worktree"
        ;;
    list)
        git -C "$repo_root" worktree list
        ;;
    remove)
        [ "$#" -eq 2 ] || { usage >&2; exit 2; }
        task_slug=$(slugify "$2")
        worktree="$worktree_root/$task_slug"
        [ -d "$worktree" ] || { printf 'worktree not found: %s\n' "$worktree" >&2; exit 1; }
        git -C "$repo_root" worktree remove "$worktree"
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac
