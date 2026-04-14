# Claude Code Skills

Collection of Claude Code skills, plugins, and tools.

## Skills

### Git Workflow Plugin

Complete git workflow automation with emoji-based conventional commits, PR creation, review remediation, and merge monitoring.

**Install from GitHub (Recommended):**
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

See [git-workflow-local/README.md](git-workflow-local/README.md) for full documentation.

## Scripts

### pr-monitor-merge.sh

Standalone bash script for monitoring and merging PRs when all checks pass.

**Usage:**
```bash
chmod +x pr-monitor-merge.sh
./pr-monitor-merge.sh <pr-number> [commit-message]
```

## License

MIT

## Contributing

Contributions welcome! Feel free to add your own skills and tools.
