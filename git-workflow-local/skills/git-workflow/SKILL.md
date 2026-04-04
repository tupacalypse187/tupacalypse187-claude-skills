---
name: git-workflow
description: Complete git workflow automation for feature development. Use when creating feature branches, making commits, creating PRs, addressing reviews, monitoring PR status, merging, and cleaning up branches. Covers the full PR lifecycle from branch creation to merge including review remediation.
---

# Git Workflow Automation

Complete git workflow automation for feature development lifecycle from branch creation to merge.

---

## Overview

This skill automates the complete feature development workflow:

1. **Create feature branch** from main
2. **Commit changes** with emoji conventional commits
3. **Push to remote**
4. **Create PR** with structured markdown template
5. **Poll for reviews** — wait for code review comments
6. **Evaluate and remediate** — categorize and fix each comment
7. **Push fixes and reply** — push changes, acknowledge every comment
8. **Loop** — re-check for new feedback on fixes
9. **Monitor status** (UNSTABLE -> CLEAN)
10. **Merge PR** (squash + delete branch)
11. **Cleanup** local and remote branches

**⚠️ MANDATORY:** When executing the full workflow, ALL 11 steps MUST execute sequentially. Do NOT stop after creating the PR (Step 4). Steps 5-11 (review, remediation, merge, cleanup) are mandatory parts of the flow, not optional follow-ups. Continue from each step to the next without stopping.

---

## Triggering the Skill

Use natural language to invoke any part of the workflow:

### Full Workflow
- "Complete git workflow for feature X"
- "Create feature branch, commit, PR, and merge"
- "Run full PR cycle"

### Individual Steps
- "Create a feature branch for X"
- "Commit my changes with emoji conventional commits"
- "Create a PR with structured template"
- "Monitor my PR status"
- "Merge the PR and cleanup"

### Review Handling
- "Check for PR comments and address them"
- "Fix review comments on PR #123"
- "Address feedback on current PR"

---

## Step 1: Create Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feat/descriptive-name
```

**Branch naming conventions:**
- `feat/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation changes
- `refactor/` - Code refactoring
- `perf/` - Performance improvements
- `test/` - Test additions/changes
- `chore/` - Maintenance tasks
- `ci/` - CI/CD changes

---

## Step 2: Commit with Emoji Conventional Commits

### Stage and Commit
```bash
git add <files>
git commit -m "<emoji> <type>[optional scope]: <description>"
```

### Commit Types & Emojis

| Type | Emoji | Description | Example |
|------|-------|-------------|---------|
| `feat` | ✨ | New feature | `✨ feat(auth): add JWT token validation` |
| `fix` | 🐛 | Bug fix | `🐛 fix(api): resolve memory leak in handler` |
| `docs` | 📝 | Documentation | `📝 docs: update API endpoints documentation` |
| `style` | 🎨 | Code style | `🎨 style: format code with prettier` |
| `refactor` | ♻️ | Code refactoring | `♻️ refactor: simplify authentication logic` |
| `perf` | ⚡️ | Performance | `⚡️ perf: optimize database query performance` |
| `test` | ✅ | Testing | `✅ test: add unit tests for user service` |
| `chore` | 🔧 | Maintenance | `🔧 chore: update build dependencies` |
| `ci` | 👷 | CI/CD | `👷 ci: add github actions workflow` |
| `build` | 📦 | Build system | `📦 build: upgrade to webpack 5` |
| `revert` | ⏪ | Revert | `⏪ revert: rollback payment integration` |

### Commit Message Format

**Simple (default):**
```
✨ feat(auth): add JWT token validation
```

**Full (with body):**
```
✨ feat(auth): add JWT token validation

Implement JWT token validation middleware that:
- Validates token signature and expiration
- Extracts user claims from payload
- Adds user context to request object

This improves security by ensuring all protected routes
validate authentication tokens properly.

Co-authored-by: Claude Opus 4.6 <noreply@anthropic.com>
```

### Best Practices

- ✅ Use present tense, imperative mood ("add" not "added")
- ✅ Keep first line under 50 characters (72 max)
- ✅ Capitalize first letter
- ✅ No period at end of subject line
- ✅ Use scope for context (e.g., `feat(auth):`)
- ✅ Include `Co-authored-by:` footer for AI-assisted commits

---

## Step 3: Push to Remote

```bash
git push -u origin feat/descriptive-name
```

---

## Step 4: Create PR with Structured Template

### Before creating the PR, analyze the actual changes:

```bash
# See all changes in this branch vs main
git diff main...HEAD

# See commit messages
git log main..HEAD --pretty=format:"%s"
```

**You MUST generate the PR title and body from the actual diff — never use placeholder text.**

- **Title:** Use the emoji and type from the primary commit (e.g., `✨ feat:`, `🐛 fix:`). Include the emoji.
- **Body:** Fill every section with REAL content derived from the diff. Do NOT write `[One-line summary]` or `[First change]` — write actual descriptions of the real changes.

```bash
gh pr create \
  --title "<EMOJI> <TYPE>: <brief description>" \
  --body "$(cat <<EOF
## 📝 Summary

[Write a REAL one-sentence summary based on the actual diff]

## 🔄 Changes

[List each meaningful change as a bullet point with an emoji prefix. Base on git diff output]

## ✅ Verification

[Provide specific, runnable verification steps based on what actually changed]

## 🔗 Sources

[Include relevant links: issue references (Closes #N), docs, related PRs. Omit section if none exist]

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### PR Template Examples

**Feature PR:**
```markdown
## 📝 Summary

Add OAuth2 authentication flow supporting Google and GitHub providers.

## 🔄 Changes

- ✨ Add OAuth2 authorization code flow with PKCE
- 🔐 Implement secure token storage with encrypted cookies
- 📝 Add user profile synchronization on first login
- 🎨 Update login UI with provider buttons

## ✅ Verification

1. Run locally: `npm run dev`
2. Visit `/login` and click "Sign in with Google"
3. Complete OAuth flow
4. Verify user profile is created correctly
5. Check token refresh works on page reload

```bash
# Test suite
npm run test:auth
```

## 🔗 Sources

- Closes #456
- OAuth 2.1 RFC: https://datatracker.ietf.org/doc/html/rfc6749
- Design doc: docs/design/oauth2-integration.md
```

**Bug Fix PR:**
```markdown
## 📝 Summary

Fix memory leak in event handler that caused increased memory usage over time.

## 🔄 Changes

- 🐛 Fix event listener not being properly removed
- ✅ Add cleanup in componentWillUnmount
- 📝 Add documentation for event handler lifecycle

## ✅ Verification

1. Open browser DevTools → Memory
2. Take heap snapshot
3. Navigate through app 10 times
4. Take another snapshot
5. Verify no detached DOM nodes

## 🔗 Sources

- Fixes #789
- Related issue: #123
```

---

## Step 5: Poll for Code Reviews

Wait for code reviews to complete before checking comments:

```bash
echo "⏳ Waiting for code reviews..."
sleep 180
```

### Fetch Review Comments

```bash
# Resolve repo slug
REPO_SLUG=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')

# List PRs
gh pr list

# View PR details
gh pr view <PR_NUMBER>

# Get inline code-level review comments (filter out replies to get originals only)
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments --jq '.[] | select(.in_reply_to_id == null) | {id: .id, path: .path, line: .line, body: .body}'

# Get issue-level comments (general PR comments)
gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments --jq '.[] | {id: .id, body: .body}'

# Get review state
gh pr view $PR_NUMBER --json reviews --jq '.reviews[] | {state: .state, body: .body, author: .author.login}'
```

---

## Step 6: Evaluate and Remediate Review Comments

### Categorize Each Comment

| Category | Action | Examples |
|----------|--------|---------|
| Must fix | Code change required | Bugs, security issues, logic errors, broken tests |
| Should fix | Code change recommended | Code style, naming, missing error handling |
| Suggestion | Optional, apply judgment | Alternative approaches, nicer patterns |
| Question | Reply only, no code change | Reviewer asking for clarification |
| Already addressed | Reply only | Comment refers to code already fixed |

### Process for Each Comment

1. **Read the referenced file** at the specified line number
2. **Make the minimal fix** needed to address the feedback
3. **Stage and commit** with appropriate emoji commit
4. **Track the comment ID** for replying later

```bash
# Make the fix
# ... code changes ...

# Commit the fix
git add <changed-files>
git commit -m "🐛 fix: address review feedback - handle edge case"
```

---

## Step 7: Push Fixes and Reply to Every Comment

After all fixes are committed:

```bash
# Push all fix commits
git push
```

Before replying, compute the fix hash:
```bash
FIX_HASH=$(git rev-parse --short HEAD)
```

Then for each comment, reply using the shell variable `$FIX_HASH` and the literal numeric `id` from Step 5's fetch:
```bash
# Reply to inline review comment
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments \
  --method POST \
  --field body="✅ Fixed in $FIX_HASH. <describe what was actually changed>" \
  --field in_reply_to=$COMMENT_ID

# Reply to general PR comment (note: GitHub API creates a new top-level comment, not a threaded reply — this is an API limitation)
gh api repos/$REPO_SLUG/issues/$PR_NUMBER/comments \
  --method POST \
  --field body="✅ Addressed in $FIX_HASH. <describe what was actually changed>"
```

Reply format:
- Fixes: `✅ Fixed in <short_hash> — <what was changed>`
- Questions: `💡 <answer>`
- Suggestions not applied: `🙏 Good suggestion, but <reason>. Happy to revisit if needed.`

---

## Step 8: Loop — Re-check for New Feedback

After pushing fixes:

```bash
# Re-fetch comments and compare against already-processed IDs
gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments --jq '.[] | select(.in_reply_to_id == null) | .id'
```

- If new comment IDs found → repeat from Step 6
- If no new comments → proceed to Step 9

### Common Review Responses

| Comment Type | Response Approach |
|--------------|-------------------|
| Code style | Fix + `🎨 style:` commit |
| Bug report | Fix + `🐛 fix:` commit |
| Missing tests | Add tests + `✅ test:` commit |
| Documentation | Update docs + `📝 docs:` commit |
| Performance | Optimize + `⚡️ perf:` commit |
| Refactoring | Refactor + `♻️ refactor:` commit |

---

## Step 9: Monitor PR Status (UNSTABLE -> CLEAN)

Use this monitoring loop to wait for all CI checks to pass:

```bash
#!/bin/bash
PR_NUMBER="<PR_NUMBER>"

for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus')

  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed! Ready to merge."
    exit 0
  fi

  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done

echo "❌ Timeout - checks did not pass within 10 minutes"
exit 1
```

**Possible statuses:**
- `UNKNOWN` - Status not yet determined
- `BEHIND` - Branch is behind base branch
- `BLOCKED` - Blocked by failing checks
- `DIRTY` - Merge conflict
- `DRAFT` - PR is in draft state
- `UNSTABLE` - Checks have not passed yet
- `CLEAN` - All checks passed, ready to merge

---

## Step 10: Merge PR (Squash + Delete Branch)

```bash
gh pr merge <PR_NUMBER> --squash --delete-branch
```

**Note:** Omitting `--subject` lets GitHub default to the PR title, which already has the correct emoji/type prefix.

**Merge options:**
- `--squash` - Combine all commits into one (recommended)
- `--merge` - Merge with full commit history
- `--rebase` - Rebase commits onto base branch
- `--delete-branch` - Delete branch after merge

---

## Step 11: Cleanup Local and Remote Branches

```bash
# Switch back to main
git checkout main

# Pull latest changes
git pull origin main

# Delete local branch
git branch -d feat/descriptive-name

# Force delete if needed
git branch -D feat/descriptive-name

# Delete remote branch (if not already deleted)
git push origin --delete feat/descriptive-name
```

---

## Complete Workflow Script

Here's a complete script that combines the full workflow (monitor, remediate, merge, cleanup):

```bash
#!/bin/bash
set -e

PR_NUMBER="<PR_NUMBER>"
REPO_SLUG=$(gh repo view --json nameWithOwner --jq '.nameWithOwner')

# Step 5: Wait for reviews
echo "⏳ Waiting 120 seconds for code reviews..."
sleep 180

# Step 6-8: Remediation loop (max 5 iterations)
PROCESSED_IDS=""
MAX_ITERATIONS=5
iteration=0
while [ $iteration -lt $MAX_ITERATIONS ]; do
  iteration=$((iteration + 1))
  COMMENT_IDS=$(gh api repos/$REPO_SLUG/pulls/$PR_NUMBER/comments --jq '.[] | select(.in_reply_to_id == null) | .id')
  NEW_IDS=$(comm -23 <(echo "$COMMENT_IDS" | sort) <(echo "$PROCESSED_IDS" | sort) || true)

  if [ -z "$NEW_IDS" ]; then
    echo "✅ No new review comments."
    break
  fi

  echo "📝 New review comments found. Addressing..."
  # (Claude Code evaluates and fixes each comment here)

  git push
  PROCESSED_IDS="${PROCESSED_IDS}
${NEW_IDS}"

  echo "⏳ Waiting for CI and re-review..."
  sleep 60
done

if [ $iteration -ge $MAX_ITERATIONS ]; then
  echo "⚠️ Maximum remediation iterations reached. Manual review may be needed."
fi

# Step 9: Monitor PR status
echo "🔍 Monitoring PR #$PR_NUMBER status..."
HEAD_BRANCH=$(gh pr view $PR_NUMBER --json headRefName --jq '.headRefName')
for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus')

  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed!"
    break
  fi

  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done

# Step 10: Merge PR
echo "🔀 Merging PR #$PR_NUMBER..."
gh pr merge $PR_NUMBER --squash --delete-branch

# Step 11: Cleanup
echo "🧹 Cleaning up..."
git checkout main
git pull origin main
git branch -D "$HEAD_BRANCH" 2>/dev/null || true
echo "✅ Done! Ready for next feature."
```

---

## Quick Reference Commands

### Branch Operations
```bash
git checkout -b feat/feature-name    # Create feature branch
git checkout main && git pull        # Sync with main
git branch -d feat/feature-name      # Delete local branch
git push origin --delete feat/...    # Delete remote branch
```

### Commit Operations
```bash
git add .                            # Stage all changes
git commit -m "✨ feat: description"  # Commit with emoji
git push -u origin feat/...          # Push with upstream tracking
```

### PR Operations
```bash
gh pr create                         # Create PR interactively
gh pr list                           # List open PRs
gh pr view <number>                  # View PR details
gh pr merge <number> --squash        # Merge PR
```

### Status & Monitoring
```bash
git status                           # Working tree status
gh pr checks                         # View CI status
gh pr view <number> --json status    # Get PR status JSON
```

---

## Important Notes

- **NEVER commit directly to main** unless explicitly instructed
- **Always use feature branches** for changes
- **Write meaningful commit messages** with emoji prefixes
- **Keep PRs focused** on a single change
- **Address all review comments** before requesting merge
- **Wait for CI to pass** before merging
- **Squash merges** keep main history clean
- **Delete branches** after merging to keep repo clean

---

## Common Gotchas

### 1. Merge Conflicts
**Problem**: PR shows `DIRTY` status with merge conflicts.

**Solution**:
```bash
git checkout main
git pull origin main
git checkout feat/your-branch
git merge main
# Resolve conflicts
git add .
git commit -m "🔧 chore: resolve merge conflicts"
git push
```

### 2. Behind Base Branch
**Problem**: PR shows `BEHIND` status.

**Solution**:
```bash
git checkout main
git pull origin main
git checkout feat/your-branch
git merge main
git push
```

### 3. Pre-commit Hooks Failing
**Problem**: Commit blocked by linters/tests.

**Solution**:
```bash
# Run checks manually first
npm run lint
npm run test

# Or skip hooks (not recommended for production)
git commit --no-verify -m "message"
```

### 4. PR Template Not Applied
**Problem**: Created PR without proper template.

**Solution**: Always use `gh pr create --body` with heredoc or create PR template file in `.github/pull_request_template.md`

---

## Example Usage Sessions

### Session 1: Quick Bug Fix
```
User: Create a fix for the login bug

Claude:
1. Creating fix/login-timeout branch
2. Adding timeout handling to auth service
3. Committing with: 🐛 fix(auth): increase login timeout to 30s
4. Pushing to remote
5. Creating PR with template
6. Monitoring status...
```

### Session 2: Feature with Review
```
User: Complete workflow for user profile feature

Claude:
1. Creating feat/user-profile branch
2. Implementing profile components
3. ✅ feat: add profile picture upload
4. ✅ feat: add profile edit form
5. ✅ test: add profile unit tests
6. Creating PR...
7. Waiting for review...
8. Review comment: "Add validation for image size"
9. Addressing: 🐛 fix: add image size validation
10. Pushing fix...
11. Monitoring status: UNSTABLE -> CLEAN
12. Merging with squash...
13. Cleaning up branches...
14. Done!
```

---

## Integration with Other Skills

This skill works well with:

- **commit-commands** - For detailed conventional commit creation
- **feature-dev** - For feature development workflow
- **code-review** - For reviewing PRs
- **github** - For GitHub API operations
