#!/usr/bin/env bash
# Replay only our commits even when ImSapphire/frame has been force-pushed.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
branch=experiment/frame-rs-main
base=refs/heads/experiment/frame-base
state=$(git rev-parse --git-path frame-refresh-target)
initial=de47f96fec2feb775e843e09c9c4695ef4d84aa0

die() { printf '%s\n' "$*" >&2; exit 1; }
rebasing() {
    test -d "$(git rev-parse --git-path rebase-merge)" ||
        test -d "$(git rev-parse --git-path rebase-apply)"
}
finish() {
    IFS= read -r target < "$state"
    git merge-base --is-ancestor "$target" HEAD || die 'Unexpected rebase target.'
    git update-ref "$base" "$target"
    # Keep the state file empty after success; never delete repository data.
    : > "$state"
    printf 'Updated %s; frame base is %s\n' "$branch" "$target"
}

case "${1:-}" in
    --continue)
        test -s "$state" || die 'No pending frame refresh.'
        if rebasing; then
            git rebase --continue
        fi
        test "$(git branch --show-current)" = "$branch" || die "Switch to $branch first."
        finish
        exit
        ;;
    --abort)
        test -s "$state" || die 'No pending frame refresh.'
        rebasing || die 'No active rebase; inspect the saved backup before recovering manually.'
        git rebase --abort
        : > "$state"
        exit
        ;;
    '') ;;
    *) die 'Usage: bash tools/refresh-frame.sh [--continue|--abort]' ;;
esac

test ! -s "$state" || die 'Pending refresh: use --continue or --abort.'
if rebasing; then die 'Another rebase is in progress.'; fi
test "$(git branch --show-current)" = "$branch" || die "Switch to $branch first."
test -z "$(git status --porcelain)" || die 'Commit or stash working tree changes first.'

old=$(git rev-parse --verify "$base" 2>/dev/null || git rev-parse "$initial^{commit}")
git merge-base --is-ancestor "$old" HEAD || die 'Saved frame base is not an ancestor of this branch.'
# Explicit + accepts a remote history rewrite without guessing a fork point.
git fetch --no-tags ImSapphire +refs/heads/frame:refs/remotes/ImSapphire/frame
target=$(git rev-parse refs/remotes/ImSapphire/frame)
if test "$old" = "$target"; then
    printf 'Already based on ImSapphire/frame (%s).\n' "$target"
    exit
fi

backup="refs/heads/backup/frame-refresh/$(date -u +%Y%m%dT%H%M%SZ)-$$"
git update-ref "$backup" HEAD ''
printf 'Backup: %s\n' "$backup"
printf '%s\n' "$target" > "$state"
if git rebase --onto "$target" "$old" "$branch"; then
    finish
else
    printf 'Resolve conflicts, git add the files, then run:\n  bash tools/refresh-frame.sh --continue\nOr cancel with:\n  bash tools/refresh-frame.sh --abort\n' >&2
    exit 1
fi
