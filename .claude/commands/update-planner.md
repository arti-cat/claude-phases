---
allowed-tools: Bash(curl:*), Bash(wget:*), Bash(git:*), Write, Read
argument-hint: [source-path-or-url]
description: Update the planner system from source while preserving project PLAN.md
model: sonnet
---

# Update Planner System

Updates the claude-phases planner system to the latest version while preserving your project's custom PLAN.md file.

## Usage

```
/update-planner                          # Update from default GitHub source
/update-planner /path/to/source          # Update from local path
/update-planner https://github.com/...   # Update from custom GitHub repo
```

## What Gets Updated

- `.claude/agents/planner.md` - Latest planner agent with new features
- `.claude/commands/plan.md` - Updated plan command
- `README.md` - Latest documentation (if you want to update it)

## What's Preserved

- Your project's `PLAN.md` - Your custom plan is never touched
- Any generated phase commands/agents - These are your project-specific
- Other custom commands and agents you've created

## Process

1. **Backup current system** (creates `.claude-backup/` directory)
2. **Fetch latest files** from source
3. **Update core components** while preserving customizations
4. **Report changes** made to the system

## Default Source

By default, updates from the official claude-phases repository:
- GitHub: `https://raw.githubusercontent.com/your-org/claude-phases/main`
- Local development: `/home/bch/dev/00_RELEASE/claude-phases`

## Safety Features

- **Automatic backup** before any changes
- **Preserves customizations** - only updates core system files
- **Reports what changed** so you know what was updated
- **Rollback support** - can restore from backup if needed

Update the planner system to get the latest features, bug fixes, and improvements while keeping your project-specific configuration intact.