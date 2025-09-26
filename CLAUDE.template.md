# Claude Phases Project

This is the **claude-phases** project - a reusable dynamic planning system for Claude Code.

## Project Purpose

This project contains a complete planning system that can be copied to any project to provide phase-based development workflow:

- **Planner Agent** (`.claude/agents/planner.md`) - Specialized AI that analyzes PLAN.md files
- **Plan Command** (`.claude/commands/plan.md`) - Slash command that triggers the planner
- **Template PLAN.md** - Example structure for users to customize

## When You're Working On This Project

You are working on the **source/template project** for the claude-phases system. Changes here affect:

- The planner agent's core intelligence and capabilities
- The plan command's behavior and documentation
- The example PLAN.md template that users will customize
- The README documentation that explains the system

## When This System Is Used In Other Projects

When copied to another project, this system:

1. **Reads that project's PLAN.md** - Not this template one
2. **Generates phase commands** specific to that project's tech stack
3. **Creates specialized agents** for that project's phases
4. **Uses Context7** to fetch current documentation for that project's technologies

## Key System Features

- **Technology Detection** - Automatically detects npm, docker, database tools needed
- **Documentation Integration** - Uses Context7 MCP to fetch up-to-date docs
- **Minimal Permissions** - Each phase agent gets only necessary tools
- **UV Python Preference** - Updated to prefer modern UV for Python projects
- **Virtual Environment Awareness** - Checks for .venv activation when testing

## Important Implementation Notes

- Use **UV for Python** management (uv run, uv sync, uv add, uv pip install)
- Always **check virtual environment activation** (.venv) when testing
- Generate commands as `/phase-{slug}` format (lowercase, hyphens)
- Include **Context7 documentation verification** in generated agents
- Keep **tool permissions minimal** for each phase

## Usage Workflow

1. User customizes their project's PLAN.md
2. User runs `/plan` command
3. System generates `.claude/commands/phase-*.md` and `.claude/agents/phase-*.md` files
4. User executes phase commands like `/phase-frontend-setup`

## Copying This System

To use in another project:
```bash
# Copy the system files
cp -r .claude/ /path/to/target/project/
cp PLAN.md /path/to/target/project/  # Use as template

# Customize the target project's PLAN.md
# Run /plan in the target project
```

The system automatically adapts to the target project's structure and requirements.