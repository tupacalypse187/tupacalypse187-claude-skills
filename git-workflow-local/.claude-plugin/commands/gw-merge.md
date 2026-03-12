---
description: Monitor and merge a PR when checks pass
arguments:
  - name: pr_number
    description: Pull request number
    required: true
  - name: commit_subject
    description: Commit subject for merge (optional)
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
- `DIRTY` - Checks failed or pending
- `UNKNOWN` - Error checking status

## Commands

Use the standalone script at `~/Downloads/pr-monitor-merge.sh`:

```bash
# Monitor PR #13
~/Downloads/pr-monitor-merge.sh 13

# With custom merge message
~/Downloads/pr-monitor-merge.sh 13 "feat: Add user authentication"
```

## Manual Commands

```bash
# Check PR status
gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus'

# Merge when ready
gh pr merge $PR_NUMBER --squash --delete-branch --subject "feat: description"

# Update main
git checkout main && git pull

# Delete local branch
git branch -D feat/branch-name
```
