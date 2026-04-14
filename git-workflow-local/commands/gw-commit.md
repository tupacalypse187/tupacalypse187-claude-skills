---
description: Stage and commit changes with emoji conventional commits
arguments:
  - name: message
    description: Commit message (optional, will prompt if omitted)
    required: false
  - name: type
    description: Commit type: feat, fix, docs, style, refactor, perf, test, chore, ci, build
    required: false
---

# Git Workflow: Commit Changes

This command stages changes and creates a commit with conventional commit format using emojis.

## Conventional Commit Types

| Type | Emoji | When to use |
|------|-------|-------------|
| feat | ✨ | New feature |
| fix | 🐛 | Bug fix |
| docs | 📝 | Documentation changes |
| style | 🎨 | Code style changes (formatting) |
| refactor | ♻️ | Code refactoring |
| perf | ⚡️ | Performance improvements |
| test | ✅ | Adding or updating tests |
| chore | 🔧 | Maintenance tasks |
| ci | 👷 | CI/CD changes |
| build | 📦 | Build system changes |

## Instructions

1. Check git status to see what files changed
2. Determine the appropriate commit type based on changes
3. Generate commit message in format: `emoji type: description`
4. Stage relevant files
5. Create commit with `Co-authored-by:` footer if AI-assisted

## Commands

```bash
# Show status
git status

# Stage files
git add .

# Create commit (example)
git commit -m "✨ feat: add user authentication

Co-authored-by: Claude <noreply@anthropic.com>"
```

## Auto-detection Rules

- New files → `feat`
- Changes to `*.md` → `docs`
- Changes to `*.css`, `*.tsx` UI changes → `style`
- Changes to `package.json` → `chore`
- Changes to `*.yml`, `*.yaml` in `.github/` → `ci`
- Tests → `test`
- Bug fixes (user says "fix", "bug", "error") → `fix`
