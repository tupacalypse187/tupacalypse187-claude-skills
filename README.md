# Claude Code Skills

Personal collection of Claude Code skills, plugins, and tools.

**Status:** dormant — last updated April 2026. Currently contains a
single plugin (Git Workflow, below); no further skills are in progress.

## Contents

### Git Workflow Plugin

Complete git workflow automation with emoji-based conventional commits,
PR creation, review remediation, and merge monitoring.

**Install from GitHub (recommended):**

```bash
# Add this repo as a marketplace source
claude plugin marketplace add tupacalypse187/tupacalypse187-claude-skills

# Install the plugin
claude plugin install git-workflow@git-workflow-local
```

**Or from within a Claude Code session:**

```
/plugin marketplace add tupacalypse187/tupacalypse187-claude-skills
/plugin install git-workflow@git-workflow-local
```

**Install from local clone:**

```bash
claude plugin marketplace add /path/to/this-repo
claude plugin install git-workflow@git-workflow-local
```

**Update after changes:**

```bash
claude plugin update git-workflow@git-workflow-local
```

**Usage:**

- Natural language: "Complete git workflow for adding dark mode"
- Slash commands: `/gw-flow`, `/gw-branch`, `/gw-commit`, `/gw-pr`, `/gw-remediate`, `/gw-merge`

Full documentation:

- [git-workflow-local/README.md](git-workflow-local/README.md) — plugin overview and setup
- [git-workflow-local/skills/git-workflow/SKILL.md](git-workflow-local/skills/git-workflow/SKILL.md) — the skill definition itself

### pr-monitor-merge.sh

Standalone bash script for monitoring and merging a PR once all checks
pass.

```bash
chmod +x pr-monitor-merge.sh
./pr-monitor-merge.sh <pr-number> [commit-message]
```

## Project wiki (Zread)

This repo includes a generated wiki from the
[Zread CLI](https://zread.ai/cli) in `.zread/` — structured, browsable
documentation of the project. To regenerate after changes:

```bash
zread generate
zread browse   # open in browser
```

See [CLAUDE.md](CLAUDE.md) for version management conventions.

## License

MIT
