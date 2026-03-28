---
description: Create a pull request with structured template
arguments:
  - name: title
    description: PR title (optional, will be generated from commits if omitted)
    required: false
  - name: draft
    description: Create as draft PR
    required: false
---

# Git Workflow: Create Pull Request

This command creates a GitHub pull request with a structured template using emoji commits style.

## Instructions

1. Get current branch name
2. Get recent commits to generate summary
3. Create PR using `gh pr create` with structured body:
   - Summary
   - Changes (bullet points)
   - Verification steps
   - Sources (if applicable)

## PR Template

```markdown
## 📝 Summary
[Brief one-liner]

## 🔄 Changes
- Bullet point 1
- Bullet point 2

## ✅ Verification
- How to test the changes

## 🔗 Sources
- Links to related issues/docs

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Commands

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Check if there are commits to push
if [ -z "$(git log @{u}.. 2>/dev/null)" ] && [ -n "$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)" ]; then
  echo "No new commits to push. Please push changes first."
  exit 1
fi

# Generate PR title from recent commits if not provided
TITLE="${1:-}"
if [ -z "$TITLE" ]; then
  TITLE=$(git log -1 --pretty=%s)
fi

# Check if draft
DRAFT_FLAG=""
if [ "$2" = "--draft" ] || [ "$2" = "-d" ]; then
  DRAFT_FLAG="--draft"
fi

# Create PR
gh pr create $DRAFT_FLAG --title "$TITLE" --body "$(cat <<'EOF'
## 📝 Summary
[Please add a brief summary]

## 🔄 Changes
- [Please list the changes]

## ✅ Verification
- [How to test these changes]

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```
