# Claude Plan System

A dynamic project planning system that automatically generates phase-specific commands and agents from a structured plan.

## Overview

The Claude Plan System consists of:
- **`/plan` command** - Parses your PLAN.md file and generates phase-specific tools
- **Planner agent** - The specialized AI that analyzes your plan and creates custom commands/agents

## Quick Start

1. **Create or customize your PLAN.md** (see example template included)
2. **Run the plan command:**
   ```
   /plan
   ```
3. **Execute generated phase commands:**
   ```
   /phase-frontend-setup
   /phase-backend-api
   /phase-deployment
   ```

## Context7 Setup (Recommended)

For optimal documentation integration, install Context7 MCP server:

```bash
# Using the official installation guide
https://github.com/upstash/context7
```

**What Context7 provides:**
- **Real-time documentation** - Fetches current docs for any technology (React, Node.js, PostgreSQL, etc.)
- **Best practices verification** - Ensures generated agents use up-to-date approaches
- **Technology-aware generation** - Agents include relevant documentation snippets

**Without Context7:** The system still works but generated agents won't include current documentation insights.

## How It Works

### 1. Plan Structure

Your `PLAN.md` should contain clearly defined phases with:
- **Phase headers** (## Frontend Setup)
- **Goals** - What the phase should accomplish
- **Technologies** - Tech stack for the phase

Example phase:
```markdown
## Frontend Setup

Create a modern React application with proper tooling.

**Goals:**
- Initialize React project with Vite
- Configure TypeScript and ESLint
- Set up Tailwind CSS

**Technologies:**
- React 18
- Vite
- TypeScript
```

### 2. Dynamic Generation

When you run `/plan`, the planner agent:
1. **Analyzes** your PLAN.md structure
2. **Identifies** required tools for each phase (npm, docker, git, etc.)
3. **Generates** `.claude/commands/phase-{name}.md` files
4. **Creates** `.claude/agents/phase-{name}.md` with specialized instructions
5. **Verifies** approaches using up-to-date documentation

### 3. Phase Execution

Each generated command like `/phase-frontend-setup` includes:
- **Minimal tools** - Only what's needed for that phase
- **Specialized agent** - Knows the specific technologies and goals
- **Documentation-verified approaches** - Uses latest best practices

## Features

- **Technology-aware** - Automatically detects npm, docker, database tools needed
- **Documentation-integrated** - Uses [Context7 MCP](https://github.com/upstash/context7) to fetch up-to-date docs for any technology mentioned
- **Minimal permissions** - Each phase agent only gets necessary tools
- **Consistent naming** - Predictable `/phase-{slug}` command pattern
- **Project-agnostic** - Works with any tech stack or project type

## Command Reference

| Command | Purpose |
|---------|---------|
| `/plan` | Parse PLAN.md and generate all phase commands |
| `/phase-{name}` | Execute a specific phase (auto-generated) |
| `/init-project-context` | Transform CLAUDE.md from template to project-specific context |
| `/update-planner` | Update the planner system while preserving customizations |

## File Structure

```
project/
    PLAN.md                           # Your project plan
    .claude/
       commands/
           plan.md                   # The /plan command
            phase-frontend-setup.md  # Generated commands
            phase-backend-api.md      # (auto-created)
       agents/
            planner.md                # The planner agent
            phase-frontend-setup.md   # Generated agents
            phase-backend-api.md      # (auto-created)
```

## Getting Started with a New Project

### Option 1: GitHub Template (Recommended)
1. **Use as template** on GitHub to create a clean copy for your project
2. **Customize PLAN.md** for your specific project requirements
3. **Initialize project context**: `/init-project-context`
4. **Generate phase commands**: `/plan`

### Option 2: Manual Copy
```bash
# 1. Copy the system to your project
cp -r .claude/ /your/project/
cp PLAN.md /your/project/  # Use as template

# 2. Customize PLAN.md for your project
cd /your/project/
vim PLAN.md  # Edit to match your project's phases and tech stack

# 3. Initialize project-specific context (reads your PLAN.md)
/init-project-context

# 4. Generate phase commands from your customized plan
/plan
```

## Example Workflow

```bash
# 1. First customize your PLAN.md for your project
# (Edit PLAN.md to match your specific project needs)

# 2. Transform CLAUDE.md from template to your project context
/init-project-context "E-commerce Platform"

# 3. Generate phase commands from your PLAN.md
/plan

# 4. Execute phases in order
/phase-frontend-setup
/phase-backend-api
/phase-deployment
```

Each phase command automatically includes the right tools and expertise for that specific part of your project.

## Tips

- **Be specific** in your PLAN.md goals and technologies
- **Run `/plan`** whenever you update your PLAN.md
- **Execute phases sequentially** - they may build on each other
- **Customize generated commands** if needed after generation

The system adapts to any project type - from web apps to data pipelines to mobile development.