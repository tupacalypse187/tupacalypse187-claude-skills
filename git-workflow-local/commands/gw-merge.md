---
description: Monitor and merge a PR when checks pass
arguments:
  - name: pr_number
    description: Pull request number
    required: true
  - name: commit_subject
    description: Commit subject for squash merge (optional)
    required: false
---

# Git Workflow: Monitor and Merge PR

This command monitors a PR for check completion and automatically merges when all checks pass.

## Instructions

1. Get PR number from user
2. Poll PR status every 10 seconds (up to 10 minutes)
3. When status is `CLEAN`, merge with squash
4. Delete remote branch
5. Switch to main and pull
6. Delete local feature branch

## Status Values

- `CLEAN` - All checks passed, ready to merge
- `MERGED` - Already merged
- `CLOSED` - PR was closed
- `DIRTY` - Checks failed or merge conflict
- `BEHIND` - Branch is behind base, needs rebase/merge
- `UNSTABLE` - Checks pending or failed
- `UNKNOWN` - Error checking status

## Commands

```bash
# Get PR head branch name for cleanup
HEAD_BRANCH=$(gh pr view $PR_NUMBER --json headRefName --jq '.headRefName')

# Monitor PR status
for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus' 2>/dev/null || echo "UNKNOWN")

  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed!"
    break
  fi

  if [ "$pr_status" = "MERGED" ]; then
    echo "✅ PR already merged!"
    git checkout main && git pull
    exit 0
  fi

  if [ "$pr_status" = "CLOSED" ]; then
    echo "❌ PR was closed!"
    exit 1
  fi

  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done

# Check if we exited due to CLEAN status or timeout
if [ "$pr_status" != "CLEAN" ]; then
  echo "❌ Timed out waiting for checks to pass!"
  echo "Run 'gh pr view $PR_NUMBER' to check status"
  exit 1
fi

# Merge with squash
if [ -n "$COMMIT_SUBJECT" ]; then
  gh pr merge $PR_NUMBER --squash --delete-branch --subject "$COMMIT_SUBJECT"
else
  gh pr merge $PR_NUMBER --squash --delete-branch
fi

# Update main
git checkout main
git pull

# Delete local feature branch
git branch -D "$HEAD_BRANCH" 2>/dev/null || true

echo "✅ Done!"
```
