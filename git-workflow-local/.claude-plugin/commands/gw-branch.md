---
description: Create a new feature branch from main
arguments:
  - name: name
    description: Branch name (without feat/ prefix)
    required: true
---

# Git Workflow: Create Feature Branch

This command creates a new feature branch from main with proper naming convention.

## Branch Naming Convention

- `feat/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `chore/` - Maintenance tasks
- `test/` - Test changes

## Instructions

1. Switch to main branch
2. Pull latest changes
3. Create new branch with proper prefix
4. Show confirmation

## Commands

```bash
# Get branch name argument
BRANCH_NAME="${1:-}"

if [ -z "$BRANCH_NAME" ]; then
  echo "Usage: /branch <name>"
  echo "Example: /branch user-authentication"
  exit 1
fi

# Ensure on main and up to date
git checkout main
git pull

# Determine prefix based on name or default to feat/
PREFIX="feat/"
if [[ "$BRANCH_NAME" == fix-* ]]; then
  PREFIX="fix/"
elif [[ "$BRANCH_NAME" == docs-* ]]; then
  PREFIX="docs/"
elif [[ "$BRANCH_NAME" == refactor-* ]]; then
  PREFIX="refactor/"
elif [[ "$BRANCH_NAME" == chore-* ]]; then
  PREFIX="chore/"
elif [[ "$BRANCH_NAME" == test-* ]]; then
  PREFIX="test/"
fi

# Remove prefix if user included it
BRANCH_NAME="${BRANCH_NAME#$PREFIX}"

# Create branch
FULL_BRANCH="${PREFIX}${BRANCH_NAME}"
git checkout -b "$FULL_BRANCH"

echo "✅ Created branch: $FULL_BRANCH"
```
