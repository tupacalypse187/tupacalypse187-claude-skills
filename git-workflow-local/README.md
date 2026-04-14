# Git Workflow Plugin

Complete git workflow automation plugin for Claude Code — branch creation, emoji conventional commits, PR creation, review remediation, and merge monitoring.

## Installation

### Option 1: From GitHub (Recommended)

```bash
# Add this repo as a marketplace source
claude plugin marketplace add tupacalypse187/tupacalypse187-claude-skills

# Install the plugin
claude plugin install git-workflow@git-workflow-local
```

### Option 2: From a Claude Code session

```
/plugin marketplace add tupacalypse187/tupacalypse187-claude-skills
/plugin install git-workflow@git-workflow-local
```

### Option 3: From local clone

```bash
claude plugin marketplace add /path/to/this-repo
claude plugin install git-workflow@git-workflow-local
```

### Updating

```bash
# After pulling changes to the source directory
claude plugin update git-workflow@git-workflow-local
```

### Uninstalling

```bash
claude plugin uninstall git-workflow@git-workflow-local
```

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
5. Wait for code reviews, evaluate and fix any feedback
6. Monitor checks and merge when clean
7. Clean up branches and sync the default branch

---

### Example 2: Just Create a Branch

**You say:**
> "Create a feature branch for user authentication"

**Claude will:**
```bash
git checkout <default-branch> && git pull
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

### Example 5: Review Remediation

**You say:**
> "Check PR #13 for review comments and address them"

**Claude will:**
1. Wait for code reviews to complete
2. Fetch all inline and general review comments
3. Categorize each comment (must fix, should fix, suggestion, question)
4. Make minimal code changes for each actionable comment
5. Push fixes and reply to every comment
6. Re-monitor for new feedback (loops until clear)
7. Wait for CI checks to pass on the fixes

---

### Example 6: Monitor & Merge PR

**You say:**
> "Monitor PR #13 and merge when ready"

**Claude will:**
- Check PR status every 10 seconds
- When status is `CLEAN`, merge with squash
- Delete remote branch
- Switch to the default branch and pull
- Delete local feature branch

---

## Slash Commands

For quicker access, you can also use slash commands (prefixed with `gw-` for Git Workflow):

| Command | Description | Example |
|---------|-------------|---------|
| `/gw-flow` | Complete workflow (branch → commit → push → PR → review → merge) | `/gw-flow Add user authentication` |
| `/gw-branch` | Create a new feature branch | `/gw-branch user-authentication` |
| `/gw-commit` | Stage and commit changes with emoji | `/gw-commit` (prompts for message) |
| `/gw-pr` | Create a pull request with template | `/gw-pr "feat: Add authentication"` |
| `/gw-remediate` | Poll for review comments, fix, push, and reply | `/gw-remediate 13` or `/gw-remediate 13 180` |
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

A standalone bash script is included at the repo root (`pr-monitor-merge.sh`) for use outside Claude Code:

- Detects the default branch automatically
- Checks PR status every 10 seconds (up to 10 minutes)
- Auto-merges when all checks pass (`CLEAN` status)
- Squashes commits and deletes remote branch
- Returns to the default branch and pulls latest changes

**Usage:**
```bash
chmod +x pr-monitor-merge.sh
./pr-monitor-merge.sh 13
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
| Review feedback | "Check PR comments" / "Address review feedback" |
| Monitor & merge | "Monitor and merge my PR" / "Wait for checks and merge" |
| Everything | "Do the full git workflow" |

---

## Tips

1. **Be specific** — "Create a feature branch for S3 upload" works better than "Create a branch"
2. **Check status** — You can ask "What's the PR status?" anytime
3. **Manual control** — Claude will ask before merging, you stay in control
4. **Review remediation** — Use `/gw-remediate <PR_NUMBER>` or "Check PR comments" to handle code review feedback automatically

---

## License

MIT
