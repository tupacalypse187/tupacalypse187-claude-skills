# tupacalypse187-claude-skills

Collection of Claude Code skills, plugins, and tools.

## Skills

### Git Workflow Skill

Complete git workflow automation with emoji-based conventional commits.

**Installation:**
```bash
mkdir -p ~/.claude/plugins/marketplaces/git-workflow-local
cp -r git-workflow-local/* ~/.claude/plugins/marketplaces/git-workflow-local/
```

**Usage:**
- Natural language: "Complete git workflow for adding dark mode"
- Slash commands: `/gw-flow`, `/gw-branch`, `/gw-commit`, `/gw-pr`, `/gw-merge`

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


## Installation

1. Clone this repo or copy individual skills
2. Copy skill folders to `~/.claude/plugins/marketplaces/`
3. Restart Claude Code or reload plugins

## Contributing

Contributions welcome! Feel free to add your own skills and tools.

