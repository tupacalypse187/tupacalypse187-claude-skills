---
description: Create a pull request with structured template
arguments:
  - name: title
    description: PR title (optional, will be generated from commits if omitted)
    required: false
  - name: draft
    description: Create as draft PR (--draft or -d)
    required: false
---

# Git Workflow: Create Pull Request

This command creates a GitHub pull request with a structured template using emoji commits style.

## Instructions

1. Analyze the actual changes in the branch
2. Generate PR title with appropriate emoji
3. Generate PR body with real diff-based content
4. Create PR using `gh pr create`

## Before Creating the PR

You MUST analyze the actual changes before generating the PR title and body:

```bash
# See all changes in this branch vs main
git diff main...HEAD

# See commit messages
git log main..HEAD --pretty=format:"%s"
```

## PR Title Rules

The PR title MUST include an emoji prefix. Determine the correct emoji from the diff analysis:

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
| build | 📦 | Build system |

- If the user provides a title that already has an emoji prefix, use it as-is
- If the user provides a title without an emoji, add the appropriate emoji and type prefix
- If no title is provided, derive it from the commit history and ensure it has an emoji prefix

## Commands

```bash
# Get current branch
BRANCH=$(git branch --show-current)

# Check if there are commits to push
if [ -z "$(git log @{u}.. 2>/dev/null)" ] && [ -n "$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)" ]; then
  echo "No new commits to push. Please push changes first."
  exit 1
fi

# Determine PR title with emoji
TITLE="${1:-}"
if [ -z "$TITLE" ]; then
  TITLE=$(git log -1 --pretty=%s)
fi
# If TITLE lacks an emoji prefix, add one based on diff analysis

# Check if draft
DRAFT_FLAG=""
if [ "$2" = "--draft" ] || [ "$2" = "-d" ]; then
  DRAFT_FLAG="--draft"
fi

# Create PR with REAL content generated from the diff
gh pr create $DRAFT_FLAG --title "$TITLE" --body "$(cat <<EOF
## 📝 Summary

[Write a REAL one-sentence summary based on the actual git diff — never placeholder text]

## 🔄 Changes

[List each meaningful change as a bullet point with emoji prefix. These MUST come from analyzing git diff main...HEAD]

## ✅ Verification

[Provide specific, runnable verification steps based on what actually changed. Include exact commands and expected outcomes.]

## 🔗 Sources

[Include relevant links: issue references (Closes #N), docs, related PRs. Omit section if none exist.]

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**⚠️ CRITICAL:** Do NOT output placeholder text like `[Please add a brief summary]` or `[Please list the changes]`. Every section MUST contain real content derived from the git diff analysis. Write actual descriptions of the actual changes.
