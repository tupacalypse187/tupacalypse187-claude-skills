---
description: Complete git workflow from branch to PR
arguments:
  - name: description
    description: Brief description of the feature/change
    required: true
---

# Git Workflow: Full Workflow

This command runs the complete git workflow: create branch → commit changes → push → create PR.

## Instructions

1. Create feature branch from description
2. Stage and commit changes with emoji
3. Push to remote
4. Create PR with structured template
5. Offer to monitor and merge

## Steps

### Step 1: Create Branch
```bash
git checkout main && git pull
BRANCH_NAME="feat/$(echo '$1' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')"
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

### Step 5: Monitor & Merge (optional)
Ask user if they want to monitor the PR and merge when checks pass.
