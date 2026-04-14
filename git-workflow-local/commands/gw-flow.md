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
2. Commit changes with emoji
3. Push to remote
4. Create PR with structured template
5. Poll for code review comments and remediate
6. Monitor and merge when checks pass

## ⚠️ CRITICAL: Execute ALL 6 Steps

You MUST execute ALL 6 steps sequentially without stopping. Do NOT stop after creating the PR (Step 4). Steps 5 and 6 are mandatory parts of this workflow, not optional follow-ups. After each step completes, immediately proceed to the next.

## Steps

### Step 1: Create Branch
> After creating the branch, immediately proceed to Step 2.

```bash
DEFAULT_BRANCH=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | sed 's/.*: //' || echo "main")
git checkout "$DEFAULT_BRANCH" && git pull
BRANCH_NAME="feat/$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')"
git checkout -b "$BRANCH_NAME"
```

### Step 2: Commit Changes
> After committing, immediately proceed to Step 3.

Analyze `git status` and `git diff --staged` to determine the commit type, then use the matching emoji:

| Type | Emoji | When |
|------|-------|------|
| feat | ✨ | New feature |
| fix | 🐛 | Bug fix |
| docs | 📝 | Documentation |
| style | 🎨 | Code formatting |
| refactor | ♻️ | Refactoring |
| perf | ⚡️ | Performance |
| test | ✅ | Tests |
| chore | 🔧 | Maintenance |
| ci | 👷 | CI/CD |

```bash
git status
git add .
git commit -m "<EMOJI> <TYPE>: $1"
```

### Step 3: Push
> After pushing, immediately proceed to Step 4.

```bash
git push -u origin "$BRANCH_NAME"
```

### Step 4: Create PR
> After creating the PR, IMMEDIATELY proceed to Step 5. Do NOT stop here.

**Before creating the PR, analyze the actual changes:**

```bash
# See all changes in this branch vs the default branch
git diff "$DEFAULT_BRANCH"...HEAD

# See commit messages
git log "$DEFAULT_BRANCH"..HEAD --pretty=format:"%s"
```

Use the same emoji/type from Step 2 for the PR title. Generate the PR body with REAL content from the diff — never use placeholder text.

```bash
gh pr create --title "<EMOJI> <TYPE>: $1" --body "$(cat <<EOF
## 📝 Summary

[Write a REAL one-sentence summary based on the actual diff — not placeholder text]

## 🔄 Changes

[List each meaningful change as a bullet point with emoji prefix. Base on the actual git diff output]

## ✅ Verification

[Provide specific, runnable verification steps based on what actually changed]

## 🔗 Sources

[Include relevant links: issue references (Closes #N), docs, related PRs. Omit if none exist]

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**Extract the PR number** from the `gh pr create` output URL (e.g., `https://github.com/owner/repo/pull/42` → `PR_NUMBER=42`). Then IMMEDIATELY proceed to Step 5.

### Step 5: Review Remediation
> ⚠️ IMPORTANT: You MUST proceed to this step after PR creation. Do not stop.

Wait for code reviews to appear, then evaluate and address each comment.

```bash
# Wait for reviews
echo "⏳ Waiting 180 seconds for code reviews..."
sleep 180
```

Then for each review comment found:

1. **Fetch all review comments:**

```bash
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

3. **Reply to each review comment:**

   Before replying, compute the fix hash and capture each comment's ID:
   ```bash
   FIX_HASH=$(git rev-parse --short HEAD)
   ```

   Then for each comment, reply using the shell variable `$FIX_HASH` and the literal numeric `id`:
   ```bash
   # Reply to inline review comment (use the real comment id from the fetch step)
   gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments \
     --method POST \
     --field body="✅ Fixed in $FIX_HASH. <describe what was actually changed>" \
     --field in_reply_to=$COMMENT_ID

   # Reply to general PR comment (note: this creates a new top-level comment — GitHub API limitation)
   gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments \
     --method POST \
     --field body="✅ Addressed in $FIX_HASH. <describe what was actually changed>"
   ```

4. **Loop** — re-check for new comments on the fixes. If new comments exist, repeat from step 2. **Maximum 5 iterations** — after 5 rounds, stop and inform the user that manual intervention may be needed.

### Step 6: Monitor & Merge
> After remediation is complete, immediately proceed to monitor and merge.

Monitor CI checks and merge when clean:

```bash
HEAD_BRANCH=$(gh pr view $PR_NUMBER --json headRefName --jq '.headRefName')

for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus')
  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed!"
    gh pr merge $PR_NUMBER --squash --delete-branch --subject "<EMOJI> <TYPE>: $1"
    git checkout "$DEFAULT_BRANCH" && git pull
    git branch -D "$HEAD_BRANCH" 2>/dev/null || true
    break
  fi
  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done
```

Use the same emoji and type determined in Step 2 for the merge subject.
