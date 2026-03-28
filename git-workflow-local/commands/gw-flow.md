---
description: Complete git workflow from branch to merged PR (includes review remediation)
arguments:
  - name: description
    description: Brief description of the feature/change
    required: true
---

# Git Workflow: Full Workflow

This command runs the complete git workflow: create branch → commit changes → push → create PR → address reviews → monitor & merge.

## Instructions

1. Create feature branch from description
2. Stage and commit changes with emoji
3. Push to remote
4. Create PR with structured template
5. Poll for code review comments and remediate
6. Monitor and merge when checks pass

## Steps

### Step 1: Create Branch
```bash
git checkout main && git pull
BRANCH_NAME="feat/$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')"
git checkout -b "$BRANCH_NAME"
```

### Step 2: Commit Changes
```bash
git status
# Determine commit type from changes
git add .
git commit -m "✨ feat: $1"
```

### Step 3: Push
```bash
git push -u origin "$BRANCH_NAME"
```

### Step 4: Create PR
```bash
gh pr create --title "✨ feat: $1" --body "$(cat <<EOF
## 📝 Summary
$1

## 🔄 Changes
- [Changes will be listed here]

## ✅ Verification
- [How to verify]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Capture the PR number from the output for the next steps.

### Step 5: Review Remediation
Wait for code reviews to appear, then evaluate and address each comment.

```bash
# Wait for reviews (code reviews typically take a few minutes)
echo "⏳ Waiting 180 seconds for code reviews..."
sleep 180
```

Then for each review comment found:

1. **Fetch all review comments:**

```bash
# Get the repo slug from the remote
REPO_SLUG=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')

# Inline code-level review comments
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments --jq '.[] | select(.in_reply_to_id == null) | {id: .id, path: .path, line: .line, body: .body}'

# General PR comments
gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments --jq '.[] | {id: .id, body: .body}'

# Review state
gh pr view $PR_NUMBER --json reviews --jq '.reviews[] | {state: .state, body: .body, author: .author.login}'
```

2. **For each comment requiring code changes:**
   - Read the referenced file and understand the feedback
   - Make the minimal fix needed
   - Commit with emoji conventional commit:
     ```bash
     git add <changed-files>
     git commit -m "🐛 fix: address review feedback - <description>"
     ```
   - Push all fixes:
     ```bash
     git push
     ```
   - Reply to each comment:
     ```bash
     # Capture the fix commit hash before replying
     FIX_HASH=$(git rev-parse --short HEAD)

     # Reply to inline review comment
     gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments \
       --method POST \
       --field body="✅ Fixed in $FIX_HASH. <what changed>" \
       --field in_reply_to=<comment_id>

     # Reply to general PR comment
     gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments \
       --method POST \
       --field body="✅ Addressed in $FIX_HASH. <what changed>"
     ```

3. **Loop** — re-check for new comments on the fixes. If new comments exist, repeat from step 2. Continue until no new feedback.

### Step 6: Monitor & Merge
Monitor CI checks and merge when clean:

```bash
# Get head branch for cleanup
HEAD_BRANCH=$(gh pr view $PR_NUMBER --json headRefName --jq '.headRefName')

for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus')
  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed!"
    gh pr merge $PR_NUMBER --squash --delete-branch --subject "✨ feat: $1"
    git checkout main && git pull
    git branch -D "$HEAD_BRANCH" 2>/dev/null || true
    break
  fi
  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done
```
