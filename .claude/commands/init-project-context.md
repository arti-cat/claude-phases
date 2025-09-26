---
allowed-tools: Read, Write, Edit
argument-hint: [project-name] [project-description]
description: Transform CLAUDE.md from template to project-specific context
---

# Initialize Project Context

Transforms the generic claude-phases CLAUDE.md into project-specific context based on your PLAN.md file.

## Usage

```
/init-project-context                                    # Auto-detect from PLAN.md
/init-project-context "E-commerce Platform"             # Specify project name
/init-project-context "Data Pipeline" "ML training pipeline for customer analytics"
```

## What This Does

1. **Reads your PLAN.md** to understand the actual project
2. **Replaces generic template context** with project-specific information
3. **Preserves system knowledge** about how the planner works
4. **Updates project identity** so Claude knows what you're actually building

## Before (Template)
```markdown
# Claude Phases Project
This is the **claude-phases** project - a reusable dynamic planning system...
```

## After (Your Project)
```markdown
# E-commerce Platform

This project uses the claude-phases system to manage development of an e-commerce platform.

## Project Overview
- **Frontend**: React 18 with TypeScript and Tailwind CSS
- **Backend**: Node.js with Express and PostgreSQL
- **Testing**: Jest and Playwright for comprehensive coverage
```

## Auto-Detection Logic

Extracts from your PLAN.md:
- **Project title** from first heading or inferred from phases
- **Tech stack** from Technologies sections
- **Architecture** from phase descriptions
- **Key features** from Goals sections

## When to Run This

- **After copying** claude-phases system to a new project
- **After major PLAN.md changes** that shift project identity
- **Before team onboarding** to give proper context

## Safety

- **Backs up original** CLAUDE.md as CLAUDE.template.md
- **Preserves planner knowledge** about how the system works
- **Can be re-run** if project evolves

Transform your project from a generic template to a contextually-aware development environment.