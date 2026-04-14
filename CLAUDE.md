# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Claude Code plugin** (`git-workflow`) that automates the full feature development lifecycle: branch creation, emoji conventional commits, PR creation with structured templates, review remediation, PR monitoring, merging, and branch cleanup. It contains no compilable code — only markdown-based slash commands, skill definitions, and a standalone bash script.

## Architecture

```
.claude-plugin/
│   └── marketplace.json               # Marketplace listing config (at repo root)
git-workflow-local/                    # The plugin directory
├── .claude-plugin/
│   └── plugin.json                    # Plugin metadata (only this goes in .claude-plugin/)
├── commands/                          # At plugin root, NOT inside .claude-plugin/
│   ├── gw-flow.md                     # /gw-flow — full workflow (branch→commit→push→PR→review→merge)
│   ├── gw-branch.md                   # /gw-branch — create feature branch from the default branch
│   ├── gw-commit.md                   # /gw-commit — emoji conventional commit
│   ├── gw-pr.md                       # /gw-pr — create PR with structured template
│   ├── gw-remediate.md                # /gw-remediate — poll reviews, fix, push, reply
│   └── gw-merge.md                    # /gw-merge — monitor and merge PR
└── skills/
    └── git-workflow/
        └── SKILL.md                   # Complete skill definition (11-step workflow)

pr-monitor-merge.sh                    # Standalone bash script for PR polling/auto-merge
```

## Conventions

- **Emoji Conventional Commits** — Format: `emoji type[optional scope]: description` (e.g., `✨ feat: add feature`, `🐛 fix(scope): description`). Each type has a specific emoji prefix.
- **Branch Naming** — Prefixes: `feat/`, `fix/`, `docs/`, `refactor/`, `perf/`, `test/`, `chore/`, `ci/`.
- **PR Template** — Sections: Summary, Changes, Verification, Sources, plus Claude Code attribution footer.
- **Squash Merging** — PRs merged with `--squash --delete-branch`. Never commit directly to the default branch.
- **Co-authored-by** — AI-assisted commits include `Co-authored-by: Claude <noreply@anthropic.com>`.
- **Version Bumping** — Before pushing any PR that modifies plugin files (`commands/`, `skills/`, `.claude-plugin/`), increment the `version` field in both `.claude-plugin/marketplace.json` and `git-workflow-local/.claude-plugin/plugin.json` using semver (e.g., `1.1.0` → `1.2.0`). Claude Code uses the version to determine if an update is needed — without a bump, users won't receive the changes.

## Development

There is no build system, test suite, or linting. All plugin components are markdown files. To test changes:

```bash
# Install from GitHub (recommended)
claude plugin marketplace add tupacalypse187/tupacalypse187-claude-skills
claude plugin install git-workflow@git-workflow-local

# Or from local source for development
claude plugin marketplace add /path/to/this-repo
claude plugin install git-workflow@git-workflow-local

# Or from within a Claude Code session
/plugin marketplace add tupacalypse187/tupacalypse187-claude-skills
/reload-plugins
```

Available slash commands: `/gw-flow`, `/gw-branch`, `/gw-commit`, `/gw-pr`, `/gw-remediate`, `/gw-merge`

The `pr-monitor-merge.sh` script requires `gh` (GitHub CLI) and can be run directly with `bash pr-monitor-merge.sh <PR_NUMBER>`.
