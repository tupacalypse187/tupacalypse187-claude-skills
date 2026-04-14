---
description: Create a new feature branch from the default branch
arguments:
  - name: name
    description: Branch name (without feat/ prefix)
    required: true
---

# Git Workflow: Create Feature Branch

This command creates a new feature branch from the default branch with proper naming convention.

## Branch Naming Convention

- `feat/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `perf/` - Performance improvements
- `test/` - Test changes
- `chore/` - Maintenance tasks
- `ci/` - CI/CD changes

## Instructions

1. Detect the default branch name
2. Switch to the default branch and pull
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

# Detect default branch and ensure up to date
DEFAULT_BRANCH=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | sed 's/.*: //' || echo "main")
git checkout "$DEFAULT_BRANCH"
git pull

# Determine prefix based on name or default to feat/
PREFIX="feat/"
if [[ "$BRANCH_NAME" == fix-* ]]; then
  PREFIX="fix/"
elif [[ "$BRANCH_NAME" == docs-* ]]; then
  PREFIX="docs/"
elif [[ "$BRANCH_NAME" == refactor-* ]]; then
  PREFIX="refactor/"
elif [[ "$BRANCH_NAME" == perf-* ]]; then
  PREFIX="perf/"
elif [[ "$BRANCH_NAME" == test-* ]]; then
  PREFIX="test/"
elif [[ "$BRANCH_NAME" == chore-* ]]; then
  PREFIX="chore/"
elif [[ "$BRANCH_NAME" == ci-* ]]; then
  PREFIX="ci/"
fi

# Remove prefix if user included it
BRANCH_NAME="${BRANCH_NAME#$PREFIX}"

# Create branch
FULL_BRANCH="${PREFIX}${BRANCH_NAME}"
git checkout -b "$FULL_BRANCH"

echo "✅ Created branch: $FULL_BRANCH"
```
