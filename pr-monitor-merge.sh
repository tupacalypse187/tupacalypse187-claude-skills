#!/bin/bash
# PR Monitor & Merge Script
# Usage: ./pr-monitor-merge.sh <PR_NUMBER> [commit_subject]

set -e

PR_NUMBER="${1:-}"
COMMIT_SUBJECT="${2:-}"

if [ -z "$PR_NUMBER" ]; then
  echo "Usage: $0 <PR_NUMBER> [commit_subject]"
  echo "Example: $0 13 'feat: Add user-friendly error handling'"
  exit 1
fi

# Resolve head branch name for cleanup later
HEAD_BRANCH=$(gh pr view "$PR_NUMBER" --json headRefName --jq '.headRefName' 2>/dev/null || echo "")

echo "🔍 Monitoring PR #$PR_NUMBER..."
echo ""

for i in {1..60}; do
  pr_status=$(gh pr view "$PR_NUMBER" --json mergeStateStatus --jq '.mergeStateStatus' 2>/dev/null || echo "UNKNOWN")

  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed!"
    echo ""

    if [ -n "$COMMIT_SUBJECT" ]; then
      echo "🔄 Merging PR..."
      gh pr merge "$PR_NUMBER" --squash --delete-branch --subject "$COMMIT_SUBJECT"
    else
      echo "🔄 Merging PR..."
      gh pr merge "$PR_NUMBER" --squash --delete-branch
    fi

    echo ""
    echo "📥 Updating main branch..."
    git checkout main
    git pull

    if [ -n "$HEAD_BRANCH" ]; then
      echo "🧹 Cleaning up local branch: $HEAD_BRANCH..."
      git branch -D "$HEAD_BRANCH" 2>/dev/null || true
    fi

    echo ""
    echo "✅ Done!"
    exit 0
  fi

  if [ "$pr_status" = "MERGED" ]; then
    echo "✅ PR already merged!"
    git checkout main
    git pull
    exit 0
  fi

  if [ "$pr_status" = "CLOSED" ]; then
    echo "❌ PR was closed!"
    exit 1
  fi

  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done

echo ""
echo "⏰ Timeout - PR not ready after 10 minutes"
echo "Run 'gh pr view $PR_NUMBER' to check status"
exit 1
