# Git Workflow Skill

Complete git workflow automation skill for Claude Code.

## Installation

This skill is installed at:
```
~/.claude/plugins/marketplaces/git-workflow-local/
```

No additional setup needed - Claude Code will auto-detect it.

---

## How to Use

Simply talk to Claude Code in natural language! Here are practical examples:

### Example 1: Full Workflow (Start to Finish)

**You say:**
> "Complete git workflow for adding dark mode to the settings page"

**Claude will:**
1. Create branch `feat/dark-mode-settings`
2. Commit your changes with `✨ feat(ui): add dark mode to settings page`
3. Push to remote
4. Create PR with structured template
5. Wait for you to approve, then monitor and merge
6. Clean up branches and sync main

---

### Example 2: Just Create a Branch

**You say:**
> "Create a feature branch for user authentication"

**Claude will:**
```bash
git checkout main && git pull
git checkout -b feat/user-authentication
```

---

### Example 3: Commit Your Changes

**You say:**
> "Commit my changes with an emoji commit message"

**Claude will:**
- Stage modified files
- Create commit like `✨ feat: add user login functionality`
- Include `Co-authored-by:` footer if AI-assisted

---

### Example 4: Create a PR

**You say:**
> "Create a pull request with a structured template"

**Claude will:**
```bash
gh pr create \
  --title "✨ feat: add user authentication" \
  --body "## 📝 Summary
Add OAuth2 login flow...
"
```

---

### Example 5: Monitor & Merge PR

**You say:**
> "Monitor PR #13 and merge when ready"

**Claude will:**
- Check PR status every 10 seconds
- When status is `CLEAN`, merge with squash
- Delete remote branch
- Switch to main and pull
- Delete local branch

---

## Slash Commands

For quicker access, you can also use slash commands (prefixed with `gw-` for Git Workflow):

| Command | Description | Example |
|---------|-------------|---------|
| `/gw-flow` | Complete workflow (branch → commit → push → PR) | `/gw-flow Add user authentication` |
| `/gw-branch` | Create a new feature branch from main | `/gw-branch user-authentication` |
| `/gw-commit` | Stage and commit changes with emoji | `/gw-commit` (prompts for message) |
| `/gw-pr` | Create a pull request with template | `/gw-pr "feat: Add authentication"` |
| `/gw-merge` | Monitor and merge a PR when checks pass | `/gw-merge 13` |

**Note:** Natural language triggers still work! Use whichever you prefer.

---

## Commit Types Reference

| What you did | Say this | Commit format |
|--------------|----------|---------------|
| New feature | "Commit my feature" | `✨ feat: description` |
| Bug fix | "Commit the bug fix" | `🐛 fix: description` |
| Documentation | "Commit docs update" | `📝 docs: description` |
| Code style | "Commit formatting" | `🎨 style: description` |
| Refactor | "Commit refactor" | `♻️ refactor: description` |
| Performance | "Commit optimization" | `⚡️ perf: description` |
| Tests | "Commit tests" | `✅ test: description` |
| Maintenance | "Commit dependency update" | `🔧 chore: description` |
| CI/CD | "Commit workflow update" | `👷 ci: description` |
| Build | "Commit webpack update" | `📦 build: description` |

---

## PR Template Structure

When creating PRs, Claude uses this structure:

```markdown
## 📝 Summary
[Brief one-liner]

## 🔄 Changes
- Bullet point 1
- Bullet point 2

## ✅ Verification
- How to test the changes
- What to check before merging

## 🔗 Sources
- Links to related issues/docs

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

---

## PR Monitoring Script

The skill includes a monitoring script that:
- Checks PR status every 10 seconds (up to 10 minutes)
- Auto-merges when all checks pass (`CLEAN` status)
- Squashes commits and deletes remote branch
- Returns to main and pulls latest changes

**Script location:** `~/Downloads/pr-monitor-merge.sh`

**Usage:**
```bash
# Monitor PR #13
./pr-monitor-merge.sh 13

# With custom merge message
./pr-monitor-merge.sh 13 "feat: Add user authentication"
```

---

## Common Phrases to Trigger the Skill

| Task | What to Say |
|------|-------------|
| Full workflow | "Complete git workflow for X" |
| Branch only | "Create a feature branch" / "Start a new branch" |
| Commit only | "Commit my changes" / "Stage and commit" |
| PR only | "Create a PR" / "Make a pull request" |
| Monitor & merge | "Monitor and merge my PR" / "Wait for checks and merge" |
| Reviews | "Check PR comments" / "Address review feedback" |
| Everything | "Do the full git workflow" |

---

## Tips

1. **Be specific** - "Create a feature branch for S3 upload" works better than "Create a branch"
2. **Check status** - You can ask "What's the PR status?" anytime
3. **Manual control** - Claude will ask before merging, you stay in control
4. **Review first** - Use "Check for PR comments" before merging to address feedback

---

## License

MIT
