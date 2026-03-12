---
name: git-workflow
description: Complete git workflow automation for feature development. Use when creating feature branches, making commits, creating PRs, addressing reviews, monitoring PR status, merging, and cleaning up branches. Covers the full PR lifecycle from branch creation to merge.
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
5. **Monitor PR** for comments/reviews
6. **Address reviews** with fixes
7. **Monitor status** (UNSTABLE -> CLEAN)
8. **Merge PR** (squash + delete branch)
9. **Cleanup** local and remote branches
10. **Sync** with main

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

```bash
gh pr create \
  --title "✨ feat: brief description" \
  --body "$(cat <<'EOF'
## 📝 Summary

[One-line summary of what this PR does and why]

## 🔄 Changes

- [First change with bullet point]
- [Second change]
- [Third change]

## ✅ Verification

[How to verify this change works]

```bash
# Example verification steps
npm test
npm run build
# Or manual testing steps
```

## 🔗 Sources

[Include any relevant links:
- Issue references: Closes #123
- Documentation links
- Related PRs
- Design docs]

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

## Step 5: Monitor PR for Comments/Reviews

```bash
# List PRs
gh pr list

# View PR details
gh pr view <PR_NUMBER>

# View PR comments
gh pr view <PR_NUMBER> --json comments --jq '.comments[].body'

# View review comments
gh pr view <PR_NUMBER> --json reviews --jq '.reviews[].body'
```

---

## Step 6: Address Review Comments

### Process for Addressing Feedback

1. **Read and understand** each comment
2. **Make fixes** in your branch
3. **Commit fixes** with appropriate emoji commits
4. **Push changes** to update the PR
5. **Reply to comments** to acknowledge fixes

### Example: Fixing Review Comments

```bash
# Make the fix
# ... code changes ...

# Commit the fix
git add <changed-files>
git commit -m "🐛 fix: address review comment - handle edge case"

# Push to update PR
git push

# Reply to comment (optional)
gh pr edit <PR_NUMBER> --add-assignee <reviewer>
```

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

## Step 7: Monitor PR Status (UNSTABLE -> CLEAN)

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

## Step 8: Merge PR (Squash + Delete Branch)

```bash
gh pr merge <PR_NUMBER> --squash --delete-branch --subject "✨ feat: brief description"
```

**Merge options:**
- `--squash` - Combine all commits into one (recommended)
- `--merge` - Merge with full commit history
- `--rebase` - Rebase commits onto base branch
- `--delete-branch` - Delete branch after merge

---

## Step 9: Cleanup Local and Remote Branches

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

## Step 10: Sync with Main

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Optional: Create new branch for next feature
git checkout -b feat/next-feature
```

---

## Complete Workflow Script

Here's a complete script that combines steps 7-10 (monitor, merge, cleanup):

```bash
#!/bin/bash
set -e

PR_NUMBER="<PR_NUMBER>"
BRANCH_NAME="feat/descriptive-name"

# Step 7: Monitor PR status
echo "🔍 Monitoring PR #$PR_NUMBER status..."
for i in {1..60}; do
  pr_status=$(gh pr view $PR_NUMBER --json mergeStateStatus --jq '.mergeStateStatus')

  if [ "$pr_status" = "CLEAN" ]; then
    echo "✅ All checks passed!"
    break
  fi

  echo "⏳ Waiting... ($i/60) - status: $pr_status"
  sleep 10
done

# Step 8: Merge PR
echo "🔀 Merging PR #$PR_NUMBER..."
gh pr merge $PR_NUMBER --squash --delete-branch --subject "feat: brief description"

# Step 9: Cleanup
echo "🧹 Cleaning up..."
git checkout main
git pull origin main
git branch -D $BRANCH_NAME 2>/dev/null || true

# Step 10: Sync with main
echo "✅ Synced with main! Ready for next feature."
git status
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
